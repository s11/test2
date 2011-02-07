# == Schema Information
# Schema version: 20091007002944
#
# Table name: users
#
#  id                      :integer(4)      not null, primary key
#  username                :string(100)     not null
#  crypted_password        :string(32)      default(""), not null
#  firstname               :string(100)     not null
#  lastname                :string(100)     not null
#  email                   :string(100)
#  year_level              :string(32)
#  state                   :string(128)
#  course_idnumber         :string(255)
#  role_shortname          :string(50)      default("student"), not null
#  student_id              :string(32)
#  spare_text              :text(2147483647
#  spare1                  :string(50)      default("+10.0")
#  video_size              :integer(4)      default(1), not null
#  created_at              :datetime        not null
#  updated_at              :datetime        not null
#  deleted_at              :datetime
#  lock_version            :integer(4)      default(1)
#  netsuite_contact_id     :integer(4)
#  client_id               :integer(4)      not null
#  persistence_token       :string(255)     not null
#  single_access_token     :string(255)     not null
#  perishable_token        :string(255)     not null
#  login_count             :integer(4)      default(0), not null
#  failed_login_count      :integer(4)      default(0), not null
#  last_request_at         :datetime
#  current_login_at        :datetime
#  last_login_at           :datetime
#  current_login_ip        :string(255)
#  last_login_ip           :string(255)
#  moodle_session_password :string(255)
#  menu_version_id         :integer(4)
#

# 
#  user.rb
#  online
#  
#  Created by John Meredith on 2008-03-10.
#  Copyright 2008 CDX Global. All rights reserved.
#
class User < ActiveRecord::Base
  # Behaviours ---------------------------------------------------------------------------------------------------------------------
  acts_as_reportable
  acts_as_authentic do |c|  # authlogic
    c.logged_in_timeout = Settings.session.timeout

    c.login_field       = :username
    c.validations_scope = :client_id
    c.crypto_provider   = Authlogic::CryptoProviders::MD5

    c.validate_login_field(false) # Don't validate the username
    c.validate_email_field(false) # Don't validate the email address

    c.validates_length_of_password_field_options  :within => 4..40, :if => :require_password?
  end
  has_messages              # pluginaweek-has_messages



  # Attributes ---------------------------------------------------------------------------------------------------------------------
  attr_accessor   :csv_line_number
  attr_protected  :spare1, :spare_text
  attr_readonly   :id, :client_id, :username, :role_shortname

  alias_attribute :role, :role_shortname
  alias_attribute :use_code, :jbp_access_code
  
  
  # Associations -------------------------------------------------------------------------------------------------------------------
  belongs_to  :client
  belongs_to  :menu_version, :include => :menu
  has_many    :terms_and_conditions_acceptances

  has_many  :access_packs

  has_many  :activity_logs
  has_many  :daily_activity_logs

  has_many  :tasksheet_submissions
  has_many  :tasksheets, :through => :tasksheet_submissions
  has_many  :natef_certified_areas, :through => :client

  has_many  :diagnostics_exams, :class_name => 'Diagnostics::Exam'

  has_many  :reports,              :as => :owner
  has_many  :activity_reports,     :class_name => "Report::Activity",    :as => :owner
  has_many  :assessment_reports,   :class_name => "Report::Assessment",  :as => :owner
  has_many  :diagnostics_reports,  :class_name => "Report::Diagnostics", :as => :owner
  has_many  :tasksheet_reports,    :class_name => "Report::Tasksheet",   :as => :owner

  has_one   :moodle_user, :class_name => "Moodle::User", :foreign_key => "username"
  has_many  :quiz_attempts, :through => :moodle_user

  has_and_belongs_to_many :class_groups



  # Callbacks ----------------------------------------------------------------------------------------------------------------------
  after_create      :create_moodle_user
  after_save        :sync_moodle_user, :update_client_supervisor_details
  after_destroy     :destroy_moodle_user


  
  # Validations --------------------------------------------------------------------------------------------------------------------
  validates_presence_of :client_id, :username, :firstname, :lastname, :crypted_password, :role_shortname
  # only require email if the jbp_access_code is present (i.e. only if the user was created by the jbp use code redemption)
  validates_presence_of :email, :if => :jbp_access_code
  
  # Usernames have to be handled carefully as we have a 
  with_options :on => :create do |opts|
    opts.validates_inclusion_of   :role_shortname,  :in => %w( supervisor instructor student )
    opts.validates_associated     :client
    
    opts.validates_format_of      :username, :with => /^[a-zA-Z0-9@.\-_]+$/
    opts.validates_length_of      :username, :within => 3..100
  end

  # Every user must have an associated Moodle user. We only trigger this validation on update as the Moodle user is only created
  # *after* the online user
  validates_associated :moodle_user, :on => :update

  validates_length_of :password, :within => 4..40, :if => :require_password?
  validates_format_of :password, :with => /^[a-zA-Z0-9]+$/, :message => "must be alphanumeric", :if => :require_password?

  # validate maximum lengths only if it is supplied, this way it wont be fired if they leave the field blank.
  validates_length_of :use_code, :maximum => 20, :if => :jbp_access_code
  validates_length_of :lastname, :maximum => 100, :if => :lastname
  validates_length_of :firstname, :maximum => 100, :if => :firstname
  validates_length_of :email, :maximum => 100, :if => :email

  # Scopes -------------------------------------------------------------------------------------------------------------------------
  default_scope :conditions => "#{table_name}.deleted_at IS NULL OR #{table_name}.deleted_at > UTC_TIMESTAMP()"
  named_scope :with_netsuite_id,  :conditions => "netsuite_contact_id IS NOT NULL"

  # FIXME: This need to be supersceded by a proper role-based authorisation scheme
  named_scope :supervisor,        :conditions => "username='supervisor' OR role_shortname='supervisor'"
  named_scope :instructors,       :conditions => { :role_shortname => 'instructor' }
  named_scope :students,          :conditions => { :role_shortname => 'student' }
  named_scope :not_students,      :conditions => { :role_shortname => ['instructor', 'supervisor'] }


  named_scope :by_role,             lambda { |role_name|    { :conditions => { :role_shortname => role_name }}}
  named_scope :by_menu_version,     lambda { |menu_version| { :conditions => { :menu_version_id => menu_version.id }}}
  named_scope :by_menu_version_id,  lambda { |ids|          { :conditions => { :menu_version_id => ids }}}
  
  

  # FIXME:  At some stage I'd like to change all references to client.users.students to client.users.current.students instead of
  #         having the condition on the has_many. This would allow us to specify client.users.deleted.users plus it's more natural
  #         to read
  named_scope :current,           :conditions => ["deleted_at IS NULL OR deleted_at > ?", Time.now]
  named_scope :current_before,    lambda { |finish| { :conditions => ["(deleted_at IS NULL AND created_at < :finish) OR (deleted_at > :finish)", {:finish => finish.to_datetime}] }}
  named_scope :current_between,   lambda { |start, finish| { :conditions => ["(deleted_at IS NULL AND created_at <= :finish) OR (deleted_at BETWEEN :start AND :finish)", {:start => start.to_datetime, :finish => finish.to_datetime.end_of_day}] }}

  named_scope :usernames,         :select => 'username'


  # Specifically for the Mesaging facebook jQuery lib. Also used in the search filter in user management.
  named_scope :name_search, lambda { |tag| { :conditions => ["LOWER(firstname) LIKE :tag OR LOWER(lastname) LIKE :tag OR LOWER(username) LIKE :tag OR LOWER(student_id) LIKE :tag OR LOWER(year_level) LIKE :tag", {:tag => "%#{tag.try(:downcase)}%"}] } }
  

  # TODO: Is there a more succinct way of doiing this?
  def self.find_deleted_by_netsuite_id(client, netsuite_id)
    with_exclusive_scope( :find => { :conditions => { :client_id => client, :netsuite_contact_id => netsuite_id }}) { first }
  end

  # TODO: Is there a more succinct way of doiing this?
  def self.find_deleted_by_username(client, username)
    with_exclusive_scope( :find => { :conditions => { :client_id => client, :username => username }}) { first }
  end

  
  # The user's full name
  def fullname
    [firstname, lastname].join(' ')
  end
  
  # Alternate way to show the user's fullname
  def reverse_fullname
    "#{lastname}, #{firstname}"
  end



  # Mark the model deleted_at as now.
  def destroy_without_callbacks
    self.class.update_all("deleted_at=UTC_TIMESTAMP()", "id = #{self.id}")
    self
  end

  # Override the default destroy to allow us to flag deleted_at.
  # This preserves the before_destroy and after_destroy callbacks.
  # Because this is also called internally by Model.destroy_all and
  # the Model.destroy(id), we don't need to specify those methods
  # separately.
  def destroy
    return false if callback(:before_destroy) == false
    result = destroy_without_callbacks
    callback(:after_destroy)
    self
  end

  # Returns true if this record has been destroyed ie. flagged as deleted
  def destroyed?
    deleted_at.present?
  end
  alias_method :deleted?, :destroyed?

  # "Undeletes" the user by resetting the deleted_at field. We need to use SQL here or the default_scope will interject 'deleted_at IS NULL' etc.
  def undelete
    connection.execute("UPDATE users SET deleted_at=NULL WHERE id=#{ self.id }") if deleted_at.present?
  end

  # TODO: Replace with is_paranoid. Will have to move access pack expiry dates to separate field first.
  def self.find_with_destroyed(*args)
    with_exclusive_scope { find(*args) }
  end

  # TODO: Replace with is_paranoid. Will have to move access pack expiry dates to separate field first.
  def self.count_with_destroyed(*args)
    with_exclusive_scope { count(*args) }
  end


  # Returns true if the user has accepted the latest terms and conditions
  def accepted_latest_terms_and_conditions?
    terms_and_conditions_acceptances.by_terms_and_conditions( TermsAndConditions.latest(menu) ).count > 0
  end


  # If the user hasn't been setup with a menu version, delegate to the client's. Supervisor's role is *always* the same as the one
  # defined for the client.
  def menu_version_with_client_delegation
    return client.menu_version if role.supervisor?
    
    menu_version_without_client_delegation || client.menu_version
  end
  alias_method_chain :menu_version, :client_delegation

  # Return the user's menu via the menu_version. Will delegate to the client's menu if unset
  def menu
    menu_version.menu
  end

  # A delegate method to return all the menu and version specific content categories
  def categories
    menu_version.categories
  end

  # Returns all the class groups this user belongs to that include an instructor
  def class_groups_with_supervisor
    class_groups_including_role(:supervisor)
  end

  # Returns all the class groups this user belongs to that include an instructor
  def class_groups_with_instructors
    class_groups_including_role(:instructor)
  end

  # Returns all the class groups this user belongs to that include at least one student
  def class_groups_with_students
    class_groups_including_role(:student)
  end

  # Returns all the class groups this user belongs to that include at least one student
  def class_groups_with_supervisor_or_instructors
    (class_groups_with_instructors << class_groups_with_supervisor).flatten.compact.uniq
  end

  # --------------------------------------------------------------------------
  # Reporting
  # --------------------------------------------------------------------------
  
  # NOTE: Deprecated.
  def date_last_accessed
    last_request_at
  end

  # The number of page views for this student
  def total_page_views
    activity_logs.count
  end

  # The number of page views in the last 30 days
  def total_page_views_in_last_30_days
    activity_logs.in_last(30.days).count
  end

  # The number of sessions for this user
  def total_sessions
    activity_logs.count(:select => "login_at", :distinct => true)
  end

  # The number of sessions in the last 30 days
  def total_sessions_in_last_30_days
    activity_logs.in_last(30.days).count(:select => "login_at", :distinct => true)
  end

  # Total number of approved tasksheets
  def total_tasksheets
    tasksheet_submissions.approved.count
  end

  # Total number of approved tasksheets in the last 30 days
  def total_tasksheets_in_last_30_days
    tasksheet_submissions.approved.in_last(30.days).count
  end


  # --------------------------------------------------------------------------
  # Moodle
  # --------------------------------------------------------------------------
  # Returns the role of the user wrapped in StringInquirer. This allow us to do User.role.supervisor?
  def role
    ActiveSupport::StringInquirer.new(read_attribute(:role_shortname))
  end


  # Returns true if the user is a student
  #
  # DEPRECATED: User user.role.student? instead
  def student?
    role.student?
  end
  
  # Returns true if the user is an instructor
  #
  # DEPRECATED: User user.role.student? instead
  def instructor?
    role.instructor?
  end
  
  # Returns true if the user is the supervisor
  #
  # DEPRECATED: User user.role.supervisor? instead
  def supervisor?
    role.supervisor?
  end


  # Override to_json to only provide identifying information and nothing more
  def to_json_with_limit(options = {})
    { :caption => "#{fullname} (#{username})", :value => id }.to_json
  end
  alias_method_chain :to_json, :limit

  # Delegate reader method for client's time_zone
  def time_zone
    client.time_zone
  end
  
  protected
    # Custom unique constraint on create that takes the deleted_at field into account (which is provided by the default_scope above)
    def validate_on_create
      errors.add("username", "has already been taken") if client.users.count(:id, :conditions => { :username => username }) > 0
    end

    # Updated the client clear-text password if the user is a supervisor and
    # the password has changed.
    def update_client_supervisor_details
      if role.supervisor?
        client.client_email = email
        client.client_pwd   = password if password.present?
        client.save!
      end
    end


  private
    # Time.zone is set per request from the instance's setting
    def time_zone_offset
      ActiveSupport::TimeZone[ time_zone ].utc_offset / 1.hour
    end

    # Returns the time zone offset in hours which Moodle requires
    def moodle_time_zone
      time_zone_offset / 1.hour
    end

    # Creates a new moodle user and associates it with the just created user
    def create_moodle_user
      if self.username == 'supervisor'
        # If we're creating a supervisor (which only happend on instance creation)
        # then just hijack the already present supervisor account copied from moodle_master2
        return ::Moodle::User.update(3, :username => id, :icq => username)
      else
        return ::Moodle::User.create!(
          :username       => id,
          :password       => crypted_password,
          :firstname      => firstname,
          :lastname       => lastname,
          :email          => email      || '',
          :icq            => username,
          :student_id     => student_id || '',
          :timezone       => moodle_time_zone,
          :role_shortname => role_shortname
        )
      end
    end

    # Creates or updates the associated Moodle user
    def sync_moodle_user
      return if moodle_user.blank?

      moodle_user.update_attributes!(
        :password       => crypted_password,
        :firstname      => firstname,
        :lastname       => lastname,
        :email          => email || '',
        :student_id     => student_id || '',
        :timezone       => moodle_time_zone,
        :role_shortname => role_shortname
      )
    end

    # We don't want to remove the Moodle user completely. Just rename it and mark as deleted.
    #
    # NOTE: We need to do this here instead of in the Moodle::User class as the relationship is a manual one ie. not AR has_one
    def destroy_moodle_user
      Moodle::User.update_all("username='#{username}_#{self[:id]}', deleted=1", "username='#{username}'")
    end

    # Returns all the class groups this user belongs to that include at least one user with the given role
    #
    # NOTE: Using SQL as we're using has_and_belongs_to_many for class_groups <-> users which is a little restricted
    def class_groups_including_role(roles)
      role_names = [ roles ].flatten.compact.uniq.map(&:to_s)
      self.class_groups.find_by_sql(["SELECT cg.* FROM class_groups AS cg INNER JOIN class_groups_users AS cgu ON cgu.class_group_id=cg.id AND cgu.class_group_id IN (?) INNER JOIN users AS u ON u.id=cgu.user_id AND u.role_shortname IN (?)", class_group_ids, role_names * "','"])
    end
end

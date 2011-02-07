# == Schema Information
# Schema version: 20091007002944
#
# Table name: clients
#
#  id                       :integer(4)      not null, primary key
#  client_prefix            :string(4)       not null
#  client_name              :string(255)     not null
#  client_email             :string(255)     not null
#  client_pwd               :string(255)
#  client_current_logons    :integer(4)      default(0), not null
#  client_instructor_logons :integer(4)      default(1), not null
#  created_under_version    :integer(4)      default(51), not null
#  client_ole_url           :string(255)     not null
#  client_database_name     :string(255)     not null
#  client_emerg_num         :string(255)     default("")
#  client_spare3            :string(1024)    not null
#  client_spare4            :string(1024)    default("+cdxplus.com,+javascript:,+about:blank,"), not null
#  expires_on               :date            not null
#  state                    :string(255)
#  country_name             :string(255)
#  time_zone                :string(255)
#  created_at               :datetime
#  updated_at               :datetime
#  deleted_at               :datetime
#  lock_version             :integer(4)      default(1), not null
#  netsuite_customer_id     :integer(4)
#  city                     :string(255)
#  country_id               :integer(4)
#  region_id                :integer(4)
#  access_pack_lifetime     :integer(4)      default(31557600)
#  menu_version_id          :integer(4)
#

# 
#  client.rb
#  online
#  
#  Created by John Meredith on 2008-03-10.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class Client < ActiveRecord::Base
  # Attributes ---------------------------------------------------------------------------------------------------------------------
  attr_readonly :client_prefix, :client_database_name, :client_ole_url

  # Attributes aliases to make up for the badly named table fields
  alias_attribute :prefix,                    :client_prefix
  alias_attribute :name,                      :client_name
  alias_attribute :email,                     :client_email
  alias_attribute :cleartext_password,        :client_pwd
  alias_attribute :emergency_number,          :client_emerg_num
  alias_attribute :current_logons,            :client_current_logons
  alias_attribute :instructor_logons,         :client_instructor_logons
  alias_attribute :moodle_database_name,      :client_database_name



  # Behaviours ---------------------------------------------------------------------------------------------------------------------
  authenticates_many :user_sessions



  # Associations -------------------------------------------------------------------------------------------------------------------
  belongs_to :country
  belongs_to :region
  belongs_to :menu_version
  has_one :menu, :through => :menu_version
  
  # TODO: Remove all conditions on the has_many's in favour of users.current or users.deleted
  has_many  :users
  has_many  :deleted_users, :conditions => "users.deleted_at IS NOT NULL OR users.deleted_at > UTC_TIMESTAMP()",  :class_name => "User"
  has_one   :supervisor,    :conditions => "(username='supervisor' OR role_shortname='supervisor')",              :class_name => "User"
  has_many  :moodle_users,  :through => :users

  has_many  :class_groups
  has_many  :csv_files, :class_name => "CsvFile"

  has_many  :activity_logs, :through => :users
  has_many  :daily_activity_logs

  has_many  :tasksheet_submissions, :through => :users
  has_many  :natef_certified_areas, :class_name => "ClientNatefCertifiedArea"

  # Diagnostics
  has_many :diagnostics_exams, :through => :users

  # Statistics
  has_many :statistics, :class_name => "ClientStatistic", :dependent => :delete_all 

  # The following allows us to save reports
  has_many :reports,              :as => :owner
  has_many :activity_reports,     :class_name => "Report::Activity",    :as => :owner
  has_many :assessment_reports,   :class_name => "Report::Assessment",  :as => :owner
  has_many :diagnostics_reports,  :class_name => "Report::Diagnostics", :as => :owner
  has_many :tasksheet_reports,    :class_name => "Report::Tasksheet",   :as => :owner

  has_many :upgrades,     :class_name => "ClientUpgrades"
  has_many :access_packs, :class_name => "AccessPack"

  has_and_belongs_to_many :districts  # District reporting


  # Filters ------------------------------------------------------------------------------------------------------------------------
  before_validation_on_create :configure_client_before_create
  after_validation_on_update  :update_all_user_menu_versions
  after_create  'Moodle::Base.create_instance(self)'
  after_create  :assign_user_ids_to_moodle_users


  # Validations --------------------------------------------------------------------------------------------------------------------
  validates_presence_of :client_prefix, :client_name

  with_options :on => :create do |opts|
    opts.validates_presence_of    :client_prefix, :client_database_name, :client_ole_url, :client_email

    opts.validates_format_of      :client_prefix, :with => /^[\w\d]{4}$/

    opts.with_options :scope => :deleted_at do |deleted|
      deleted.validates_uniqueness_of  :client_prefix
      deleted.validates_uniqueness_of  :client_database_name
      deleted.validates_uniqueness_of  :client_ole_url
    end
  end

  validates_presence_of :client_pwd

  validates_numericality_of :client_current_logons,     :greater_than_or_equal_to => 0
  validates_numericality_of :client_instructor_logons,  :greater_than_or_equal_to => 1

  validates_uniqueness_of :netsuite_customer_id, :scope => :deleted_at, :allow_nil => true # Not all instances have a corresponding NetSuite ID so NULL is acceptable
  validates_inclusion_of  :time_zone, :in => ActiveSupport::TimeZone::ZONES.map(&:name)


  # Scopes -------------------------------------------------------------------------------------------------------------------------
  default_scope :conditions => "#{table_name}.deleted_at IS NULL"
  named_scope :current,           :conditions => [ "expires_on >= ?", Time.now ]
  named_scope :expired,           :conditions => [ "expires_on < ?", Time.now ]
  named_scope :expired_in_last,   lambda { |period| { :conditions => ['expires_on BETWEEN ? AND ?', period.ago.beginning_of_day, Date.today.beginning_of_day] } }
  named_scope :with_netsuite_id,  :conditions => "netsuite_customer_id IS NOT NULL"

  # Searchlogic scopes
  named_scope :query, lambda { |term| { :joins => :supervisor, :conditions => ['LOWER(client_prefix) LIKE :term OR LOWER(client_name) LIKE :term OR LOWER(users.firstname) LIKE :term OR LOWER(users.lastname) LIKE :term OR LOWER(client_email) LIKE :term',  { :term => "%#{term.downcase}%" }]}}


  # Preferences --------------------------------------------------------------------------------------------------------------------
  preference :assessments,          :default => true
  preference :class_groups,         :default => true
  preference :colour_legend,        :default => true
  preference :diagnostics,          :default => true
  preference :location_change,      :default => true
  preference :menu_change,          :default => true
  preference :messaging,            :default => true
  preference :reports,              :default => true
  preference :search,               :default => true

  preference :tasksheet_tracking,   :default => true
  preference :natef_version,        :string, :default => '2008'

  preference :videos,               :default => true
  preference :video_size_selection, :default => true
  preference :flash_video,          :default => false # Defaults to WMV


  # Find the specified client by FLA and set the moodle DB accordingly
  # 
  # Usage: Client.cpload('ggr2')
  # 
  # NOTE: This is used in NS scripts
  def self.cpload(prefix)
    c = Client.find_by_client_prefix!(prefix)
    Moodle::Base.setup_tables_by_client(c)
    c
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



  # 20091011 Disabled the following code as it's already been when v5.1 went live
  # 
  # # Make sure the Moodle user data is associated with the correct CDX Online user. This is a fix to what appears to have been manual
  # # intervention :-(
  # def fix_moodle_user_data_associations
  #   # Make sure we're using the correct Moodle DB
  #   Moodle::Base.setup_tables_by_client(self)
  # 
  #   # For each student, fix up the Moodle assessment data
  #   users.find_each do |user|
  #     if moodle_user = user.moodle_user
  #       if original_moodle_user = Moodle::User.first(:conditions => { :username => user.username, :deleted => 0 })
  #         # Update the Moodle user to have the correct id and username
  #         moodle_user.update_attributes(:icq => user.username)
  # 
  #         
  #         # Make sure the quizattempts for the bogus user are assigned to the original Moodle user
  #         Moodle::QuizAttempt.update_all("userid=#{moodle_user.id}", "userid=#{original_moodle_user.id}")
  #         Moodle::QuizGrade.update_all("userid=#{moodle_user.id}", "userid=#{original_moodle_user.id}")
  # 
  # 
  #         # Mark the currently incorrect Moodle user as deleted
  #         original_moodle_user.update_attributes(:deleted => 1)
  #         # Moodle::User.delete(original_moodle_user.id)
  # 
  #         puts "[#{client_prefix}] #{moodle_user.username} [#{moodle_user.id}] found. Data adjusted accordingly."
  #       else
  #         puts "[#{client_prefix}] Could not find a Moodle user with the username of '#{user.username}' (Created: #{user.created_at}), however a Moodle user exists: #{moodle_user.icq} (#{moodle_user.id})"
  #       end
  #     else
  #       puts "[#{client_prefix}] ERROR: Couldn't not find an associated Moodle user for '#{user.username}'"
  #     end
  #   end
  # end


  def title
    "#{name} [#{prefix}] - <em>Expires: #{expires_on.to_s(:long)}</em>"
  end

  # Returns true if this client is expired
  def expired?
    Time.now > expires_on
  end


  # --------------------------------------------------------------------------
  # User methods
  # --------------------------------------------------------------------------
  # Delegate method to fetch all of the students for the client
  def students
    users.students
  end
  
  # Delegate method which returns all of the instructors for the client
  def instructors
    users.instructors
  end

  # Returns a list of instructors who have been assigned to students
  def assigned_instructors
    instructors.find_all_by_username(students.all(:select => "instructor", :group => "instructor").map(&:instructor).compact)
  end
  
  # Delegate method which returns all of users who aren't students
  def not_students
    users.not_students
  end

  # Returns a list of all the usernames. Covenience method only.
  def usernames
    users.usernames.map(&:username)
  end

  # Return the maximum number of 'roles'
  def maximum_users_by_role(role = :all)
    case role.to_sym
      when :instructor
        return maximum_number_of_instructors
      when :student
        return maximum_number_of_students
      else
        return client_current_logons
    end
  end

  # There is always 1 supervisor
  def maximum_number_of_supervisors
    1
  end

  # Maximum number of instructors
  def maximum_number_of_instructors
    instructor_logons - maximum_number_of_supervisors
  end

  # Returns the maximum number of students
  def maximum_number_of_students
    current_logons - instructors.count
  end

  # Return the number of remaining instructors
  def remaining_instructors
    result = maximum_number_of_instructors - instructors.count

    return 0 if result < 0
    result
  end

  # Return the number of unallocated student slots
  def remaining_students
    result = current_logons - instructors.count - students.count
    
    return 0 if result < 0
    result
  end

  # Return the number of remaining users
  def remaining_users(role = :all)
    case role.to_sym
      when :instructor
        return remaining_instructors
      when :student
        return remaining_students
    end
  end



  # Time zones ---------------------------------------------------------------------------------------------------------------------
  # Returns the instance's time zone. Defaults to Eastern Time.
  def time_zone
    read_attribute(:time_zone).present? ? read_attribute(:time_zone) : "Eastern Time (US & Canada)"
  end



  # Class / Groups -----------------------------------------------------------------------------------------------------------------

  # Returns true if the client has classgroups
  def has_class_groups?
    class_groups.size > 0
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



  # Access packs -------------------------------------------------------------------------------------------------------------------
  # Returns true if access packs have been assigned to the instance
  def has_access_packs?
    access_packs.count > 0
  end

  # Returns true if the client has access packs assigned and some active / current
  def has_current_access_packs?
    has_access_packs? && access_packs.activated.current.count > 0
  end

  # Assigns the access packs between start_id and finish_id to this client *only if* none of the IDs in the range have previously
  # been assigned.
  def assign_access_packs(start_id, finish_id)
    return false unless AccessPack.block_free?(start_id, finish_id)

    AccessPack.update_all("client_id=#{id}", ["id BETWEEN ? AND ?", start_id, finish_id])
  end

  # Menu methods -------------------------------------------------------------------------------------------------------------------
  # Returns an array of menu versions that may be selected for users of this instance. It's grouped by the version ie. v4.1 or v5.1
  # so that if the client is in ASE v5.1, only menus which are globally available and have v5.1 maps will be returned.
  def valid_user_menu_versions
    MenuVersion.by_version_number(menu_version.version).all(:include => :menu, :conditions => { :menus => { :is_custom => false, :is_client_locked => false }}, :order => "menu_id ASC")
  end

  # Returns an array of menus that the client may be switched to
  def valid_instance_menus
    if (menu.is_custom? || menu.is_client_locked?)
      if menu_version.has_later_version?
        [ menu ]
      else
        []
      end
    else
      Menu.global
    end
  end

  # Returns all menu versions currently selected for all the users and the instance
  def assigned_menu_versions
    MenuVersion.all(
      :include    => { :menu => :versions }, 
      :joins      => :users, 
      :conditions => ["menu_versions.id = ? OR (users.client_id=? AND (users.deleted_at IS NULL OR users.deleted_at > UTC_TIMESTAMP()))", menu_version_id, id],
      :group      => "menu_id",
      :order      => "version DESC"
    ).map(&:menu).map(&:versions).flatten.compact
  end



  # Tasksheets ---------------------------------------------------------------------------------------------------------------------
  def is_tasksheet_submission_allowed?(tasksheet_id)
    # Menu's other than ASE get the automatic go-ahead
    return true unless menu.name =~ /ASE/

    descriptions = natef_certified_areas.map(&:description)
    version      = natef_certified_areas.map(&:version).uniq.first

    return NatefTaskArea.exists?(:version => version, :description => descriptions, :tasksheet_id => tasksheet_id)
  end
  
  def is_subscribed_to_natef_task_areas
    natef_certified_areas.present?
  end


  # Statistics ---------------------------------------------------------------------------------------------------------------------
  def update_statistics(reset = false)
    # Remove all previous stats
    statistics.delete_all if reset

    # For each date there has been access, generate the statistics
    puts "[#{client_prefix}] Updating statistics#{' with reset' if reset}"
    dates_accessed.each do |date|
      print "\tProcessing #{date} ..."
      update_statistics_for_date(date, reset)
      puts " done."
    end

    puts "\n\n"
  end

  # Will generate the statistics row for the client given the date
  def update_statistics_for_date(date, reset = false)
    day_stats = statistics.find_or_initialize_by_log_date(:log_date => date)

    # On the given date
    student_ids    = User.find_with_destroyed(:all, :select => 'id', :conditions => ["client_id=:client AND role_shortname='student' AND (created_at <= :finish AND (deleted_at IS NULL OR deleted_at > :finish))",     { :client => self, :finish => date.to_date.end_of_day.utc }]).map(&:id)
    instructor_ids = User.find_with_destroyed(:all, :select => 'id', :conditions => ["client_id=:client AND role_shortname='instructor' AND (created_at <= :finish AND (deleted_at IS NULL OR deleted_at > :finish))",  { :client => self, :finish => date.to_date.end_of_day.utc }]).map(&:id)
    day_stats.active_students_on_day               = ActivityLog.on_date(date).by_user(student_ids).count(:user_id, :distinct => true)
    day_stats.active_instructors_on_day            = ActivityLog.on_date(date).by_user(instructor_ids).count(:user_id, :distinct => true)
    day_stats.active_supervisor_on_day             = ActivityLog.on_date(date).by_user(supervisor).count(:user_id, :distinct => true)
    day_stats.student_page_views_on_day            = ActivityLog.on_date(date).by_user(student_ids).count(:id)
    day_stats.instructor_page_views_on_day         = ActivityLog.on_date(date).by_user(instructor_ids).count(:id)
    day_stats.supervisor_page_views_on_day         = ActivityLog.on_date(date).by_user(supervisor).count(:id)
    day_stats.student_sessions_on_day              = ActivityLog.on_date(date).by_user(student_ids).count(:login_at, :distinct => true)
    day_stats.instructor_sessions_on_day           = ActivityLog.on_date(date).by_user(instructor_ids).count(:login_at, :distinct => true)
    day_stats.supervisor_sessions_on_day           = ActivityLog.on_date(date).by_user(supervisor).count(:login_at, :distinct => true)

    # In the last 30 days from the given date
    start_date                                     = date - 30.days
    student_ids                                    = User.find_with_destroyed(:all, :select => 'id', :conditions => ["client_id=:client AND role_shortname='student' AND created_at <= :finish",    { :client => self, :finish => date.to_date.end_of_day.utc }]).map(&:id)
    instructor_ids                                 = User.find_with_destroyed(:all, :select => 'id', :conditions => ["client_id=:client AND role_shortname='instructor' AND created_at <= :finish", { :client => self, :finish => date.to_date.end_of_day.utc }]).map(&:id)
    day_stats.active_students_in_last_30days       = ActivityLog.between_dates(start_date, date).by_user(student_ids).count(:user_id, :distinct => true)
    day_stats.active_instructors_in_last_30days    = ActivityLog.between_dates(start_date, date).by_user(instructor_ids).count(:user_id, :distinct => true)
    day_stats.active_supervisor_in_last_30days     = ActivityLog.between_dates(start_date, date).by_user(supervisor).count(:user_id, :distinct => true)
    day_stats.student_page_views_in_last_30days    = ActivityLog.between_dates(start_date, date).by_user(student_ids).count(:id)
    day_stats.instructor_page_views_in_last_30days = ActivityLog.between_dates(start_date, date).by_user(instructor_ids).count(:id)
    day_stats.supervisor_page_views_in_last_30days = ActivityLog.between_dates(start_date, date).by_user(supervisor).count(:id)
    day_stats.student_sessions_in_last_30days      = ActivityLog.between_dates(start_date, date).by_user(student_ids).count(:login_at, :distinct => true)
    day_stats.instructor_sessions_in_last_30days   = ActivityLog.between_dates(start_date, date).by_user(instructor_ids).count(:login_at, :distinct => true)
    day_stats.supervisor_sessions_in_last_30days   = ActivityLog.between_dates(start_date, date).by_user(supervisor).count(:login_at, :distinct => true)

    # Total
    student_ids                                    = User.find_with_destroyed(:all, :select => 'id', :conditions => ["client_id=:client AND role_shortname='student' AND (deleted_at IS NULL OR deleted_at > :finish)",    { :client => self, :finish => date.to_date.end_of_day.utc }]).map(&:id)
    instructor_ids                                 = User.find_with_destroyed(:all, :select => 'id', :conditions => ["client_id=:client AND role_shortname='instructor' AND (deleted_at IS NULL OR deleted_at > :finish)", { :client => self, :finish => date.to_date.end_of_day.utc }]).map(&:id)
    day_stats.active_students_total                = ActivityLog.up_to_date(date).by_user(student_ids).count(:user_id, :distinct => true)
    day_stats.active_instructors_total             = ActivityLog.up_to_date(date).by_user(instructor_ids).count(:user_id, :distinct => true)
    day_stats.active_supervisor_total              = ActivityLog.up_to_date(date).by_user(supervisor).count(:user_id, :distinct => true)
    day_stats.student_page_views_total             = ActivityLog.up_to_date(date).by_user(student_ids).count(:id)
    day_stats.instructor_page_views_total          = ActivityLog.up_to_date(date).by_user(instructor_ids).count(:id)
    day_stats.supervisor_page_views_total          = ActivityLog.up_to_date(date).by_user(supervisor).count(:id)
    day_stats.student_sessions_total               = ActivityLog.up_to_date(date).by_user(student_ids).count(:login_at, :distinct => true)
    day_stats.instructor_sessions_total            = ActivityLog.up_to_date(date).by_user(instructor_ids).count(:login_at, :distinct => true)
    day_stats.supervisor_sessions_total            = ActivityLog.up_to_date(date).by_user(supervisor).count(:login_at, :distinct => true)

    # Current user counts
    day_stats.student_count       = student_ids.size
    day_stats.instructor_count    = instructor_ids.size
    day_stats.supervisor_count    = User.count_with_destroyed(:all, :select => 'id', :conditions => ["client_id=:client AND (role_shortname='supervisor' OR username='supervisor') AND (deleted_at IS NULL OR deleted_at > :finish)",    { :client => self, :finish => date.to_date.end_of_day.utc }])
    
    # Tasksheet submissions
    day_stats.pending_tasksheets  = tasksheet_submissions.pending.on_date(date).count
    day_stats.approved_tasksheets = tasksheet_submissions.approved.on_date(date).count
    day_stats.rejected_tasksheets = tasksheet_submissions.rejected.on_date(date).count
    
    # Completed quizzes & tests
    day_stats.quizzes_and_tests   = Moodle::QuizAttempt.completed.on_date(date).count
    
    if day_stats.invalid?
      logger.debug { "Errors: #{day_stats.to_yaml}" }
    end
    day_stats.save
  end


  # Reporting ----------------------------------------------------------------------------------------------------------------------

  # Returns a distinct list of dates this client has been used / accessed
  def dates_accessed
    activity_logs.all(:select => "opened_at", :group => "DATE(opened_at)", :order => "opened_at ASC").map(&:opened_at).map(&:to_date)
  end

  # The date any user of the client last accessed CDX Online
  def date_last_accessed
    users.maximum(:last_request_at)
  end

  # Total number of active users
  def total_active_users
    activity_logs.count(:user_id, :distinct => true)
  end

  # Total number of active users in the last 30 days
  def total_active_users_in_last_30_days
    activity_logs.in_last(30.days).count(:user_id, :distinct => true)
  end

  # The number of page views for this client
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

  # The number of completed quizzes and tests
  def total_quizzes_and_tests
    Moodle::QuizAttempt.completed.count
  end

  # The number of completed quizzes and tests for the last 30 days
  def total_quizzes_and_tests_in_last_30_days
    Moodle::QuizAttempt.completed.in_last(30.days).count
  end

  # Total number of approved tasksheets
  def total_tasksheets
    tasksheet_submissions.approved.count
  end

  # Total number of approved tasksheets in the last 30 days
  def total_tasksheets_in_last_30_days
    tasksheet_submissions.approved.in_last(30.days).count
  end


  # Moodle -------------------------------------------------------------------------------------------------------------------
  # Iterates over all undeleted users for the instance and assigns their ids to the respective moodle user and visa versa. To be used
  # as part of the migration to the new v5.1
  def assign_user_ids_to_moodle_users(reset = false)
    begin
      Moodle::Base.setup_tables_by_client(self)

      # Remove any Moodle users with ID usernames
      Moodle::User.destroy_all({:username => user_ids, :icq => ''}) if reset

      # Clear our the association on both sides
      Moodle::User.update_all("mnethostid=1,auth='db'") if reset

      # Update both sides of the relationship user <-> moodle user
      User.connection.execute("UPDATE users AS u, #{ client_database_name }.cdx_user AS mu SET mu.icq=mu.username, mu.username=u.id WHERE BINARY(u.username)=BINARY(mu.username) AND mu.deleted=0 AND u.deleted_at IS NULL and u.client_id=#{ read_attribute(:id) }")

      # Now see if we can update the deleted users
      User.connection.execute("UPDATE users AS u, #{ client_database_name }.cdx_user AS mu SET mu.icq=mu.username, mu.username=u.id WHERE BINARY(mu.username)=BINARY(CONCAT(u.username, '_', u.id)) AND mu.deleted=1 AND (u.deleted_at IS NOT NULL AND u.deleted_at > UTC_TIMESTAMP()) and u.client_id=#{ read_attribute(:id) }")
    rescue Exception => e
      puts e
    end
  end

  # Return all the moodle users associated with this instance
  def moodle_users
    Moodle::User.find_all_by_username(user_ids, :order => "id ASC").compact
  end

  # Return all the moodle user ids associated with this instance
  def moodle_user_ids
    Moodle::User.find_all_by_username(user_ids, :select => "id", :order => "id ASC").map(&:id).compact
  end
  

  private
    # Configures the client defaults.
    def configure_client_before_create
      write_attribute('client_ole_url',       "#{client_prefix}.moodle.cdxplus.com")
      write_attribute('client_database_name', "moodle_#{client_prefix}")
      write_attribute('client_spare3',        "+#{client_prefix}.moodle.cdxplus.com,")
      write_attribute('client_pwd',           "#{client_prefix}super%03d" % rand(1000))

      # If the expiry date hasn't been set, default to 1 year from now
      write_attribute('expires_on', 1.year.from_now) if expires_on.blank?
    end

    # If the menu_version for the client has changed, we need to ensure that all users have their menu_versions changed as well
    def update_all_user_menu_versions
      return unless changed.include?("menu_version_id")

      old_menu_version = MenuVersion.find(changes['menu_version_id'].first)
      new_menu_version = MenuVersion.find(changes['menu_version_id'].second)

      # If the version is the same, do nothing
      return if old_menu_version.version == new_menu_version.version

      # Convert the old
      MenuVersion.find_by_sql(["SELECT old.id AS old_id, new.id AS new_id FROM menu_versions AS old LEFT JOIN menu_versions AS new ON old.menu_id=new.menu_id WHERE old.version=? AND new.version=?", old_menu_version.version, new_menu_version.version]).each do |mv|
        students.update_all("menu_version_id=#{mv.new_id}", "menu_version_id=#{mv.old_id} AND menu_version_id IS NOT NULL")
        instructors.update_all("menu_version_id=#{mv.new_id}", "menu_version_id=#{mv.old_id} AND menu_version_id IS NOT NULL")
      end
    end

    # Returns all the class groups this user belongs to that include at least one user with the given role
    #
    # NOTE: Using SQL as we're using has_and_belongs_to_many for class_groups <-> users which is a little restricted
    def class_groups_including_role(role)
      self.class_groups.find_by_sql(["SELECT cg.* FROM class_groups AS cg INNER JOIN class_groups_users AS cgu ON cgu.class_group_id=cg.id AND cgu.class_group_id IN (?) INNER JOIN users AS u ON u.id=cgu.user_id AND u.role_shortname=? GROUP BY cg.id ORDER BY cg.name ASC", class_group_ids, role.to_s])
    end
end

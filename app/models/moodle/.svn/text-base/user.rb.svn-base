# == Schema Information
# Schema version: 20091007002944
#
# Table name: cdx_user
#
#  id            :integer(8)      not null, primary key
#  auth          :string(20)      default("manual"), not null
#  confirmed     :boolean(1)      not null
#  policyagreed  :boolean(1)      not null
#  deleted       :boolean(1)      not null
#  mnethostid    :integer(8)      default(0), not null
#  username      :string(100)     default(""), not null
#  password      :string(32)      default(""), not null
#  idnumber      :string(64)      default(""), not null
#  firstname     :string(100)     default(""), not null
#  lastname      :string(100)     default(""), not null
#  email         :string(100)     default(""), not null
#  emailstop     :boolean(1)      not null
#  icq           :string(15)      default(""), not null
#  skype         :string(50)      default(""), not null
#  yahoo         :string(50)      default(""), not null
#  aim           :string(50)      default(""), not null
#  msn           :string(50)      default(""), not null
#  phone1        :string(20)      default(""), not null
#  phone2        :string(20)      default(""), not null
#  institution   :string(40)      default(""), not null
#  department    :string(30)      default(""), not null
#  address       :string(70)      default(""), not null
#  city          :string(20)      default(""), not null
#  country       :string(2)       default(""), not null
#  lang          :string(30)      default("en"), not null
#  theme         :string(50)      default(""), not null
#  timezone      :string(100)     default("99"), not null
#  firstaccess   :integer(8)      default(0), not null
#  lastaccess    :integer(8)      default(0), not null
#  lastlogin     :integer(8)      default(0), not null
#  currentlogin  :integer(8)      default(0), not null
#  lastip        :string(15)      default(""), not null
#  secret        :string(15)      default(""), not null
#  picture       :boolean(1)      not null
#  url           :string(255)     default(""), not null
#  description   :text(16777215)
#  mailformat    :boolean(1)      default(TRUE), not null
#  maildigest    :boolean(1)      not null
#  maildisplay   :integer(1)      default(2), not null
#  htmleditor    :boolean(1)      default(TRUE), not null
#  ajax          :boolean(1)      default(TRUE), not null
#  autosubscribe :boolean(1)      default(TRUE), not null
#  trackforums   :boolean(1)      not null
#  timemodified  :integer(8)      default(0), not null
#  trustbitmask  :integer(8)      default(0), not null
#  imagealt      :string(255)
#  screenreader  :boolean(1)      not null
#

# 
#  user.rb
#  online
#  
#  Created by John Meredith on 2008-03-17.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class Moodle::User < Moodle::Base
  set_table_name :cdx_user


  # Attributes ---------------------------------------------------------------------------------------------------------------------
  # The following attributes are readonly from Rails
  attr_readonly :auth, :confirmed, :policyagreed, :deleted, :mnethostid, :emailstop, :aim, :msn, :phone1, :phone2, :department
  attr_readonly :address, :lang, :theme, :secret, :picture, :url, :mailformat, :maildigest, :maildisplay, :htmleditor, :ajax
  attr_readonly :autosubscribe, :trackforums, :trustbitmask, :imagealt, :screenreader, :lastip


  # Some attributes have been mis-appropriated for other non-Moodle uses. Setup some proper names.
  alias_attribute :role_shortname,  :description
  alias_attribute :student_id,      :idnumber
  alias_attribute :instructor,      :skype



  # Associations -------------------------------------------------------------------------------------------------------------------
  belongs_to  :user,                                                        :foreign_key => "username"
  has_many    :role_assignments,  :class_name => "Moodle::RoleAssignment",  :foreign_key => "userid"
  has_many    :contexts,          :class_name => "Moodle::Context",         :through => :role_assigments
  has_many    :quiz_attempts,     :class_name => "Moodle::QuizAttempt",     :foreign_key => "userid"
  
  # Diagnostics
  has_many :diagnostics_exams, :class_name => "Diagnostics::Exam"



  # Validations --------------------------------------------------------------------------------------------------------------------
  validates_uniqueness_of :username, :scope => :mnethostid



  # Callbacks ----------------------------------------------------------------------------------------------------------------------
  before_create :initialise_immutable_attributes
  after_create  :assign_global_role



  # Scopes -------------------------------------------------------------------------------------------------------------------------
  default_scope :conditions => { :deleted => 0 }



  # Clean up the description just in case
  def description
    attributes['description'].try(:strip)
  end


  # Enrol the user into all of the available courses
  # def enrol_into_all_courses
  #   # The role is help in the description field of the cdx_user table. Do
  #   # nothing if that field contains something other than the standard roles
  #   # return unless ['student', 'instructor', 'supervisor'].include?(description)
  #   
  #   Moodle::RoleAssignment.connection.execute(["DELETE FROM #{Moodle::RoleAssignment.table_name} WHERE userid = ?", id])
  # 
  #   # Grab the first Moodle::Role that corresponds to the same role as the user we're creating
  #   if role = Moodle::Role.first(:select => :id, :conditions => { :shortname => description })
  #     
  #     case role.id
  #       when 3, 4
  #         contextlevel = 40 # Course Category
  #       when 5
  #         contextlevel = 50 # Course
  #       else
  #         return  # Not an supervisor, instructor, or student. Jump.
  #     end
  #     
  #     # AFAIK, Rails won't allow easy mass-inserts/replaces. Let's use the connection and issue an SQL REPLACE with subselect instead
  #     Moodle::RoleAssignment.connection.execute("REPLACE INTO #{Moodle::RoleAssignment.table_name} (roleid, contextid, userid, timemodified, modifierid, enrol) SELECT #{role.id}, id, #{self.id}, UNIX_TIMESTAMP(), 2, 'manual' FROM #{Moodle::Context.table_name} WHERE contextlevel=#{contextlevel}")
  #   end
  # end
  
  def assign_global_role
    # Clear out all other roles assignments
    Moodle::RoleAssignment.connection.execute("DELETE FROM #{Moodle::RoleAssignment.table_name} WHERE userid = #{id}")

    # Find the appropriate role for the user.
    # 
    # NOTE: Supervisor's are treated as instructors within Moodle
    role = Moodle::Role.find_by_sql([ "SELECT * FROM #{Moodle::Role.table_name} WHERE name=? LIMIT 1", user.student? ? 'Student' : 'Instructor' ]).first

    # Now create a system wide role assignment for the user
    Moodle::RoleAssignment.connection.execute("INSERT INTO #{Moodle::RoleAssignment.table_name} (roleid, contextid, userid, timemodified, modifierid, enrol) SELECT #{role.id}, id, #{id}, UNIX_TIMESTAMP(), 2, 'manual' FROM #{Moodle::Context.table_name} WHERE contextlevel = #{Moodle::Context::CONTEXT_SYSTEM}")
  end
  
  private
    # Setup Moodle::User specific attributes once on create. These shouldn't be changed.
    def initialise_immutable_attributes
      self.auth          = 'db'
      self.confirmed     = 1
      self.policyagreed  = 1
      self.deleted       = 0
      self.mnethostid    = 1
      self.emailstop     = 1
      self.aim           = ''
      self.msn           = ''
      self.phone1        = ''
      self.phone2        = ''
      self.department    = ''
      self.address       = ''
      self.lang          = 'en'
      self.theme         = ''
      self.secret        = ''
      self.picture       = 0
      self.url           = ''
      self.mailformat    = 1
      self.maildigest    = 0
      self.maildisplay   = 2
      self.htmleditor    = 0
      self.ajax          = 0
      self.autosubscribe = 1
      self.trackforums   = 0
      self.trustbitmask  = 0
      self.imagealt      = nil
      self.screenreader  = 0
      self.lastip        = 0
    end
end

# == Schema Information
# Schema version: 20091007002944
#
# Table name: tasksheet_submissions
#
#  id             :integer(4)      not null, primary key
#  completed_on   :date            not null
#  state          :string(255)     default("pending"), not null
#  updated_at     :datetime
#  user_id        :integer(4)
#  tasksheet_id   :integer(4)      not null
#  created_at     :datetime        not null
#  lock_version   :integer(4)      default(1), not null
#  grade          :integer(4)      default(0), not null
#  deleted_at     :datetime
#  class_group_id :integer(4)
#

# 
#  tasksheet_submission.rb
#  report_rework
#  
#  Created by John Meredith on 2008-04-09.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class TasksheetSubmission < ActiveRecord::Base
  # Behaviours ---------------------------------------------------------------------------------------------------------------------
  acts_as_reportable



  # Attributes -------------------------------------------------------------------------------------------------------------------
  attr_readonly :user_id, :tasksheet_id



  # Associations -------------------------------------------------------------------------------------------------------------------
  belongs_to :class_group
  belongs_to :tasksheet
  has_many    :natef_task_areas, :through => :tasksheet
  belongs_to :user



  # Validations --------------------------------------------------------------------------------------------------------------------
  validates_presence_of     :completed_on, :state, :user_id, :tasksheet_id, :grade
  validates_associated      :user, :tasksheet, :class_group
  validates_inclusion_of    :state, :in => ['pending', 'approved', 'rejected']
  validates_numericality_of :grade, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 4
  validates_date            :completed_on, :between => lambda {[ 1.year.ago, Date.today ]}


  
  # Named scopes -------------------------------------------------------------------------------------------------------------------
  default_scope :conditions => "#{table_name}.deleted_at IS NULL OR #{table_name}.deleted_at > UTC_TIMESTAMP()"

  named_scope :by_tasksheet,    lambda { |number|       { :conditions => { :tasksheet_number => number      }}}
  named_scope :by_tasksheet_id, lambda { |ids|          { :conditions => { :tasksheet_id     => ids         }}}
  named_scope :by_user,         lambda { |users|        { :conditions => { :user_id          => users       }}}
  named_scope :by_class_group,  lambda { |class_groups| { :conditions => { :class_group_id => class_groups  }}}
  
  named_scope :grade_greater_than, lambda { |grade| { :conditions => ['grade >= ?', grade] } }

  # Allow limiting the returned submissions to the associated user's name. This is of a hack to get around Searchlogic's inability
  # to use has_many :through associations.
  named_scope :user_name_like, lambda { |username| { :conditions => ["LOWER(users.username) LIKE :term OR LOWER(users.firstname) LIKE :term OR LOWER(users.lastname) LIKE :term", {:term => "%#{username.downcase}%"}] }}
  

  # Tasksheet state scopes
  named_scope :pending,   :conditions => { :state => 'pending'  }
  named_scope :approved,  :conditions => { :state => 'approved' }
  named_scope :rejected,  :conditions => { :state => 'rejected' }
  named_scope :by_state,          lambda { |state|  { :conditions => { :state          => state }}}
  named_scope :by_class_groups,   lambda { |ids|    { :conditions => { :class_group_id => ids   }}}
  named_scope :by_natef_version,      lambda { |version|      { :joins => { :tasksheet => :natef_task_areas }, :conditions => { :tasksheet => { :natef_task_areas => { :version     => version      }}}}}
  named_scope :by_natef_description,  lambda { |description|  { :joins => { :tasksheet => :natef_task_areas }, :conditions => { :tasksheet => { :natef_task_areas => { :description => description  }}}}}
  

  # Dated scopes
  named_scope :before_date,   lambda { |date|           { :conditions => ['completed_on < ?',   date.to_datetime.end_of_day.utc] }}
  named_scope :between_dates, lambda { |start, finish|  { :conditions => ['completed_on BETWEEN ? AND ?', start.to_datetime.beginning_of_day.utc, finish.to_datetime.end_of_day.utc] }}
  named_scope :on_date,       lambda { |date|           { :conditions => ['completed_on BETWEEN ? AND ?', date.to_datetime.beginning_of_day.utc, date.to_datetime.end_of_day.utc] }}
  named_scope :in_last,       lambda { |period|         { :conditions => ['completed_on >= ?',  period.ago.to_datetime.beginning_of_day.utc] }}
  named_scope :after_date,    lambda { |date|           { :conditions => ['completed_on > ?',   date.to_datetime.beginning_of_day.utc] }}
  named_scope :yesterday,     :conditions => [ "completed_on = ?", Date.yesterday.to_date ]

  # The following scopes are mainly used for date filtering
  named_scope :completed_on_date_range,     lambda { |daterange|  { :conditions => ['completed_on BETWEEN ? AND ?', daterange.split(/ (-|to) /)[0].to_datetime.utc, daterange.split(/ (-|to) /)[-1].to_datetime.utc] }}
  named_scope :completed_on_or_before_date, lambda { |date|       { :conditions => ['completed_on <= ?',  date.to_datetime.end_of_day.utc] }}
  named_scope :completed_on_or_after_date,  lambda { |date|       { :conditions => ['completed_on >= ?',  date.to_datetime.beginning_of_day.utc] }}



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
end

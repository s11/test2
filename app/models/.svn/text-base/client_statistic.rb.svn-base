# == Schema Information
# Schema version: 20091007002944
#
# Table name: client_statistics
#
#  id                                   :integer(4)      not null, primary key
#  client_id                            :integer(4)
#  log_date                             :date
#  active_students_on_day               :integer(4)      default(0), not null
#  active_students_in_last_30days       :integer(4)      default(0), not null
#  active_students_total                :integer(4)      default(0), not null
#  active_instructors_on_day            :integer(4)      default(0), not null
#  active_instructors_in_last_30days    :integer(4)      default(0), not null
#  active_instructors_total             :integer(4)      default(0), not null
#  active_supervisor_on_day             :integer(4)      default(0), not null
#  active_supervisor_in_last_30days     :integer(4)      default(0), not null
#  active_supervisor_total              :integer(4)      default(0), not null
#  student_page_views_on_day            :integer(4)      default(0), not null
#  student_page_views_in_last_30days    :integer(4)      default(0), not null
#  student_page_views_total             :integer(4)      default(0), not null
#  student_sessions_on_day              :integer(4)      default(0), not null
#  student_sessions_in_last_30days      :integer(4)      default(0), not null
#  student_sessions_total               :integer(4)      default(0), not null
#  student_count                        :integer(4)      default(0), not null
#  instructor_page_views_on_day         :integer(4)      default(0), not null
#  instructor_page_views_in_last_30days :integer(4)      default(0), not null
#  instructor_page_views_total          :integer(4)      default(0), not null
#  instructor_sessions_on_day           :integer(4)      default(0), not null
#  instructor_sessions_in_last_30days   :integer(4)      default(0), not null
#  instructor_sessions_total            :integer(4)      default(0), not null
#  instructor_count                     :integer(4)      default(0), not null
#  supervisor_page_views_on_day         :integer(4)      default(0), not null
#  supervisor_page_views_in_last_30days :integer(4)      default(0), not null
#  supervisor_page_views_total          :integer(4)      default(0), not null
#  supervisor_sessions_on_day           :integer(4)      default(0), not null
#  supervisor_sessions_in_last_30days   :integer(4)      default(0), not null
#  supervisor_sessions_total            :integer(4)      default(0), not null
#  supervisor_count                     :integer(4)      default(0), not null
#  pending_tasksheets                   :integer(4)      default(0), not null
#  approved_tasksheets                  :integer(4)      default(0), not null
#  rejected_tasksheets                  :integer(4)      default(0), not null
#  quizzes_and_tests                    :integer(4)      default(0), not null
#

#--
#  client_statistic.rb
#  management
#  
#  Created by John Meredith on 2009-10-07.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class ClientStatistic < ActiveRecord::Base
  # Attributes ---------------------------------------------------------------------------------------------------------------------
  attr_readonly :client_id, :log_date


  # Associations -------------------------------------------------------------------------------------------------------------------
  belongs_to :client


  # Validations --------------------------------------------------------------------------------------------------------------------
  validates_presence_of :client_id, :log_date
  validates_associated :client
  validates_uniqueness_of :client_id, :scope => :log_date 
  validate :at_least_one_active_user


  # Scopes -------------------------------------------------------------------------------------------------------------------------
  named_scope :by_date,       lambda { |date|           { :conditions => { :log_date => date }}}
  named_scope :before_date,   lambda { |date|           { :conditions => ["log_date <= ?", date] }}
  named_scope :between_dates, lambda { |start, finish|  { :conditions => ["log_date >= ? AND log_date <= ?", start, finish] }}
  named_scope :after_date,    lambda { |date|           { :conditions => ["log_date >= ?", date] }}


  private
    # Validation method to check that at least one session exists for the log_date
    def at_least_one_active_user
      errors.add_to_base("There must be at least one user session") unless (student_sessions_on_day + instructor_sessions_on_day + supervisor_sessions_on_day) > 0
    end
end

# == Schema Information
# Schema version: 20091007002944
#
# Table name: cdx_quiz_attempts
#
#  id           :integer(8)      not null, primary key
#  uniqueid     :integer(8)      default(0), not null
#  quiz         :integer(8)      default(0), not null
#  userid       :integer(8)      default(0), not null
#  attempt      :integer(3)      default(0), not null
#  sumgrades    :float           default(0.0), not null
#  timestart    :integer(8)      default(0), not null
#  timefinish   :integer(8)      default(0), not null
#  timemodified :integer(8)      default(0), not null
#  layout       :text(16777215)  default(""), not null
#  preview      :integer(2)      default(0), not null
#

# 
#  quiz_attempt.rb
#  online
#  
#  Created by John Meredith on 2008-03-18.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class Moodle::QuizAttempt < Moodle::Base
  # We need to set the table name manually
  set_table_name :cdx_quiz_attempts
  read_only = true                      # All models are read-only. We're just reporting.


  # Behaviours ---------------------------------------------------------------------------------------------------------------------
  acts_as_reportable



  # Associations -------------------------------------------------------------------------------------------------------------------
  belongs_to :assessment_view, :class_name => "AssessmentView", :foreign_key => "moodle_quiz_id"
  belongs_to :quiz, :class_name => 'Moodle::Quiz', :foreign_key => 'quiz'
  belongs_to :user, :class_name => 'Moodle::User', :foreign_key => 'userid'


  # Scopes -------------------------------------------------------------------------------------------------------------------------
  default_scope :conditions => "preview=0 AND timefinish != 0"

  # Named scopes
  named_scope :previews,      :conditions => { :preview => true }
  named_scope :completed,     :conditions => "timestart < timefinish AND preview IS FALSE"
  named_scope :by_user_id,    lambda { |ids| { :joins => :user, :conditions => { :cdx_user  => { :username => ids }}}}
  named_scope :by_quiz_id,    lambda { |ids| { :joins => :quiz, :conditions => { :cdx_quiz  => { :id => ids  }}}}

  named_scope :between_dates, lambda { |start, finish|  { :conditions => ['timestart >= ? AND timestart <= ?', start.to_datetime.beginning_of_day.to_f, finish.to_datetime.end_of_day.to_f] }}
  named_scope :on_date,       lambda { |date|           { :conditions => ['timestart >= ? AND timestart <= ?', date.to_datetime.beginning_of_day.utc.to_f, date.to_datetime.end_of_day.utc.to_f] }}
  named_scope :in_last,       lambda { |period|         { :conditions => ['timestart >= ?',  period.ago.beginning_of_day.to_f ]}}
end

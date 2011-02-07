# == Schema Information
# Schema version: 20091007002944
#
# Table name: cdx_course
#
#  id              :integer(8)      not null, primary key
#  category        :integer(8)      default(0), not null
#  sortorder       :integer(8)      default(0), not null
#  password        :string(50)      default(""), not null
#  fullname        :string(254)     default(""), not null
#  shortname       :string(100)     default(""), not null
#  idnumber        :string(100)     default(""), not null
#  summary         :text(16777215)  default(""), not null
#  format          :string(10)      default("topics"), not null
#  showgrades      :integer(1)      default(1), not null
#  modinfo         :text(2147483647
#  newsitems       :integer(3)      default(1), not null
#  teacher         :string(100)     default("Teacher"), not null
#  teachers        :string(100)     default("Teachers"), not null
#  student         :string(100)     default("Student"), not null
#  students        :string(100)     default("Students"), not null
#  guest           :integer(1)      default(0), not null
#  startdate       :integer(8)      default(0), not null
#  enrolperiod     :integer(8)      default(0), not null
#  numsections     :integer(3)      default(1), not null
#  marker          :integer(8)      default(0), not null
#  maxbytes        :integer(8)      default(0), not null
#  showreports     :integer(2)      default(0), not null
#  visible         :boolean(1)      default(TRUE), not null
#  hiddensections  :integer(1)      default(0), not null
#  groupmode       :integer(2)      default(0), not null
#  groupmodeforce  :integer(2)      default(0), not null
#  lang            :string(30)      default(""), not null
#  theme           :string(50)      default(""), not null
#  cost            :string(10)      default(""), not null
#  currency        :string(3)       default("USD"), not null
#  timecreated     :integer(8)      default(0), not null
#  timemodified    :integer(8)      default(0), not null
#  metacourse      :boolean(1)      not null
#  requested       :boolean(1)      not null
#  restrictmodules :boolean(1)      not null
#  expirynotify    :boolean(1)      not null
#  expirythreshold :integer(8)      default(0), not null
#  notifystudents  :boolean(1)      not null
#  enrollable      :boolean(1)      default(TRUE), not null
#  enrolstartdate  :integer(8)      default(0), not null
#  enrolenddate    :integer(8)      default(0), not null
#  enrol           :string(20)      default(""), not null
#  defaultrole     :integer(8)      default(0), not null
#

# 
#  course.rb
#  online
#  
#  Created by John Meredith on 2008-03-18.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class Moodle::Course < Moodle::Base
  set_table_name :cdx_course

  # Associations
  belongs_to  :category,      :class_name => 'Moodle::CourseCategory',  :foreign_key => 'category'
  has_many    :quizzes,       :class_name => 'Moodle::Quiz',            :foreign_key => 'course'
  has_many    :quiz_attempts, :class_name => 'Moodle::QuizAttempt',     :through => :quizzes

  #
  # NOTE: The contextid of 50 is a Moodle designation that the context in question is a course
  #
  has_one :context, :class_name => "Moodle::Context", :foreign_key => "instanceid", :conditions => "contextlevel=50"

  #
  # Cleanup the name of the course for display purposes
  #
  def sanitized_name
    fullname.gsub(/: (Topic Group Tests|Find-the-Missing Word|Practice Exam)$/, '')
  end
end

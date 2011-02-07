# == Schema Information
# Schema version: 20091007002944
#
# Table name: cdx_quiz
#
#  id               :integer(8)      not null, primary key
#  course           :integer(8)      default(0), not null
#  name             :string(255)     default(""), not null
#  intro            :text(16777215)  default(""), not null
#  timeopen         :integer(8)      default(0), not null
#  timeclose        :integer(8)      default(0), not null
#  optionflags      :integer(8)      default(0), not null
#  penaltyscheme    :integer(2)      default(0), not null
#  attempts         :integer(3)      default(0), not null
#  attemptonlast    :integer(2)      default(0), not null
#  grademethod      :integer(2)      default(1), not null
#  decimalpoints    :integer(2)      default(2), not null
#  review           :integer(8)      default(0), not null
#  questionsperpage :integer(8)      default(0), not null
#  shufflequestions :integer(2)      default(0), not null
#  shuffleanswers   :integer(2)      default(0), not null
#  questions        :text(16777215)  default(""), not null
#  sumgrades        :integer(8)      default(0), not null
#  grade            :integer(8)      default(0), not null
#  timecreated      :integer(8)      default(0), not null
#  timemodified     :integer(8)      default(0), not null
#  timelimit        :integer(1)      default(0), not null
#  password         :string(255)     default(""), not null
#  subnet           :string(255)     default(""), not null
#  popup            :integer(2)      default(0), not null
#  delay1           :integer(8)      default(0), not null
#  delay2           :integer(8)      default(0), not null
#

# 
#  quiz.rb
#  online
#  
#  Created by John Meredith on 2008-03-18.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class Moodle::Quiz < Moodle::Base
  set_table_name :cdx_quiz

  read_only = true  # All models are read-only. We're just reporting.

  # Ruport
  acts_as_reportable

  # Associations
  has_many    :quiz_attempts,   :class_name => 'Moodle::QuizAttempt',     :foreign_key => 'quiz'
  has_one     :assessment_view, :class_name => "AssessmentView",  :foreign_key => "moodle_quiz_id"
  belongs_to  :course,          :class_name => 'Moodle::Course',          :foreign_key => 'course'

  def self.find_by_type(school, type)
    database_name = school.client_database_name

    find_by_sql(["
      SELECT q.*, c.fullname AS course_name 
        FROM `#{database_name}`.`cdx_quiz` AS q 
        LEFT JOIN `#{database_name}`.`cdx_course` AS c ON q.course=c.id
        WHERE c.fullname LIKE ?
        ORDER BY course, name
    ", "%#{type}%"])
  end

  def sanitised_name
    name.gsub(/ (topic group test|find-the-missing word)$/, '')
  end
end

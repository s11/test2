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
#  quiz_grade.rb
#  online
#  
#  Created by John Meredith on 2008-03-18.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class Moodle::QuizGrade < Moodle::Base
  # We need to set the table name manually
  set_table_name :cdx_quiz_attempts

  read_only = true                      # All models are read-only. We're just reporting.

  # Associations
  belongs_to :quiz, :class_name => 'Moodle::Quiz', :foreign_key => 'quiz'
  belongs_to :user, :class_name => 'Moodle::User', :foreign_key => 'user'

  def self.result_by_quiz(school, assessment_id)
    sql = ["SELECT avg(grade) AS average, count(DISTINCT(userid)) AS count FROM #{school.client.client_database_name}.cdx_quiz_grades WHERE quiz=? GROUP BY quiz", assessment_id]
    find_by_sql(sql)
  end
end

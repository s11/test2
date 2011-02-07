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

require 'spec_helper'

describe ClientStatistic do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    ClientStatistic.create!(@valid_attributes)
  end
end

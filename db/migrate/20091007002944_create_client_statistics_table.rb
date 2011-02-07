#--
#  20091007002944_create_client_statistics_table.rb
#  management
#  
#  Created by John Meredith on 2009-10-07.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class CreateClientStatisticsTable < ActiveRecord::Migration
  def self.up
    create_table :client_statistics, :options => 'ENGINE MyISAM COLLATE utf8_general_ci', :force => true do |t|
      t.references :client
      t.date       :log_date

      [:students, :instructors, :supervisor].each do |role|
        [:on_day, :in_last_30days, :total].each do |period|
          t.integer "active_#{role}_#{period}", :null => false, :default => 0
        end
      end

      [:student, :instructor, :supervisor].each do |role|
        [:page_views, :sessions].each do |type|
          [:on_day, :in_last_30days, :total].each do |period|
            t.integer "#{role}_#{type}_#{period}", :null => false, :default => 0
          end
        end

        t.integer "#{role}_count", :null => false, :default => 0
      end

      [:pending, :approved, :rejected].each do |status|
        t.integer "#{status}_tasksheets", :null => false, :default => 0
      end

      t.integer "quizzes_and_tests", :null => false, :default => 0
    end
    
    add_index :client_statistics, :client_id,                 :name => :idx_client
    add_index :client_statistics, :log_date,                  :name => :idx_log_date
    add_index :client_statistics, [ :client_id, :log_date ],  :name => :idx_unique,   :unique => true
  end

  def self.down
    drop_table :client_statistics
  end
end

# Customer  custrecord_os_customer  List/Record Customer    Yes
# Date  custrecord_os_date  Date      Yes
# Active Students (Daily) custrecord_os_active_students_daily Integer Number      Yes
# Active Students (Last 30 days)  custrecord_os_active_students_30days  Integer Number      Yes
# Active Students (Lifetime)  custrecord_os_active_students Integer Number      Yes
# Active Instructors (Daily)  custrecord_os_active_instructors_daily  Integer Number      Yes
# Active Instructors (Last 30 days) custrecord_os_active_instructors_30days Integer Number      Yes
# Active Instructors (Lifetime) custrecord_os_active_instructors  Integer Number      Yes
# Active Users (Daily)  custrecord_os_active_users_daily  Integer Number      Yes
# Active Users (Last 30 days) custrecord_os_active_users_30days Integer Number      Yes
# Active Users (Lifetime) custrecord_os_active_users  Integer Number      Yes
# Student Sessions  custrecord_os_sessions_students Integer Number      Yes
# Instructor Sessions custrecord_os_sessions_instructors  Integer Number      Yes
# Supervisor Sessions custrecord_os_sessions_supervisor Integer Number      Yes
# Unqualified Total Sessions  custrecord_os_unqualified_total_sessions  Integer Number      Yes
# Page Views (Students) custrecord_os_page_views_students Integer Number      Yes
# Page Views (Instructors)  custrecord_os_page_views_instructors  Integer Number      Yes
# Page Views (Supervisor) custrecord_os_page_views_supervisor Integer Number      Yes
# Unqualified Total Page Views  custrecord_os_unqualified_total_pages Integer Number      Yes
# Quizzes and Tests custrecord_os_quizzes_and_tests Integer Number      Yes
# Approved Tasksheets custrecord_os_tasksheets_approved Integer Number      Yes
# Number of Students  custrecord_os_users_students  Integer Number      Yes
# Number of Instructors custrecord_os_users_instructors Integer Number      Yes
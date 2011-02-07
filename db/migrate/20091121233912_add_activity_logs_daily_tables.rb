#--
#  20091121233912_add_activity_logs_daily_tables.rb
#  management
#  
#  Created by John Meredith on 2009-11-22.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class AddActivityLogsDailyTables < ActiveRecord::Migration
  def self.up
    create_table :activity_logs_daily, :options => 'ENGINE MyISAM COLLATE utf8_general_ci', :force => true do |t|
      t.references  :client,        :null => false
      t.references  :user,          :null => false
      t.date        :log_date,      :null => false
      t.references  :category_item, :null => false
      t.integer     :duration,      :null => false, :default => 0
    end
  end

  def self.down
    drop_table :activity_logs_daily
  end
end

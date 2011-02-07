#--
#  20091122010254_add_indices_to_activity_logs_daily_table.rb
#  management
#  
#  Created by John Meredith on 2009-11-22.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class AddIndicesToActivityLogsDailyTable < ActiveRecord::Migration
  def self.up
    add_index :activity_logs_daily, [:log_date, :category_item_id, :user_id], :unique => true, :name => :idx_unique

    add_index :activity_logs_daily, :category_item_id,  :name => :idx_category_item
    add_index :activity_logs_daily, :client_id,         :name => :idx_client
    add_index :activity_logs_daily, :user_id,           :name => :idx_user
  end

  def self.down
    remove_index :activity_logs_daily, :column => [:user_id, :category_item_id]
    remove_index :activity_logs_daily, :name => :idx_category_item
    remove_index :activity_logs_daily, :name => :idx_client
    remove_index :activity_logs_daily, :name => :idx_user
  end
end

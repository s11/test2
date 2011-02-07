#--
#  20091012004154_remove_timestamp_columns_from_class_groups_users_table.rb
#  management
#  
#  Created by John Meredith on 2009-10-12.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class RemoveTimestampColumnsFromClassGroupsUsersTable < ActiveRecord::Migration
  def self.up
    rename_table :class_groups_users, :deprecated_class_groups_users
    execute "CREATE TABLE class_groups_users LIKE deprecated_class_groups_users"

    execute "INSERT INTO class_groups_users SELECT * FROM deprecated_class_groups_users WHERE deleted_at IS NULL GROUP BY class_group_id, user_id"
    remove_timestamps :class_groups_users
    remove_column :class_groups_users, :deleted_at
    remove_column :class_groups_users, :lock_version
    
    remove_index :class_groups_users, :name => :idx_unique
    add_index :class_groups_users, [:user_id, :class_group_id], :unique => true, :name => :idx_unique
  end

  def self.down
  end
end

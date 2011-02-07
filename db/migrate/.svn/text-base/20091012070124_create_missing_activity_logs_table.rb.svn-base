#--
#  20091012070124_create_missing_activity_logs_table.rb
#  management
#  
#  Created by John Meredith on 2009-10-12.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class CreateMissingActivityLogsTable < ActiveRecord::Migration
  def self.up
    # Create a copy of the activity_logs table
    execute "CREATE TABLE missing_activity_logs LIKE activity_logs"
  end

  def self.down
    drop_table :missing_activity_logs
  end
end

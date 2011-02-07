#--
#  20091015053024_convert_moodle_topic_groups_tests_to_score_out_of_ten.rb
#  management
#  
#  Created by John Meredith on 2009-10-15.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class ConvertMoodleTopicGroupsTestsToScoreOutOfTen < ActiveRecord::Migration
  def self.up
    # Make sure moodle_master2 has been updated
    execute "UPDATE moodle_master2.cdx_quiz SET grade=10 WHERE grade=5 AND LOWER(name) LIKE '%topic%group%'"

    # Now update all the client moodle dbs
    Client.find_each(:select => "client_prefix, client_database_name") do |client|
      begin
        suppress_messages do
          execute "UPDATE #{client.client_database_name}.cdx_quiz SET grade=10 WHERE grade=5 AND LOWER(name) LIKE '%topic%group%'"
          puts "[#{client.client_prefix}] Updated #{client.client_database_name}.cdx_quiz ... done"
        end
      rescue Exception => e
        puts "[#{client.client_prefix}] Error: #{e}"
      end
    end
  end

  def self.down
  end
end

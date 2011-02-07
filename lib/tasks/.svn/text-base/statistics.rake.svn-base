#--
#  activitylog.rake
#  management
#  
#  Created by John Meredith on 2009-11-22.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
namespace :statistics do
  namespace :activity do
    namespace :daily do
      desc "Process raw log files for the given DATE='2009-01-11'"
      task :update => :environment do
        if ENV['DATE'].blank?
          puts "Usage: rake log:activity:update DATE='2009-11-22'"
          exit
        end

        DailyActivityLog.connection.execute "INSERT INTO activity_logs_daily SELECT NULL, c.id AS client_id, u.id AS user_id, DATE(al.login_at) AS log_date, al.category_item_id AS category_item_id, SUM(TIMESTAMPDIFF(SECOND, al.opened_at, COALESCE(al.closed_at, al.opened_at + INTERVAL 5 MINUTE))) AS duration FROM activity_logs AS al JOIN users AS u ON al.user_id=u.id JOIN clients AS c ON c.id=u.client_id GROUP BY al.user_id, log_date, al.category_item_id"
      end
    
      desc "Clear all daily activity logs"
      task :clear => :environment do
        DailyActivityLog.connection.execute "TRUNCATE `#{DailyActivityLog.table_name}`"
      end
      
      desc "Clear and reimport the daily activity logs"
      task :reset => :clear do
        DailyActivityLog.connection.execute "INSERT INTO activity_logs_daily SELECT NULL, c.id AS client_id, u.id AS user_id, DATE(al.login_at) AS log_date, al.category_item_id AS category_item_id, SUM(TIMESTAMPDIFF(SECOND, al.opened_at, COALESCE(al.closed_at, al.opened_at + INTERVAL 5 MINUTE))) AS duration FROM activity_logs AS al JOIN users AS u ON al.user_id=u.id JOIN clients AS c ON c.id=u.client_id GROUP BY al.user_id, log_date, al.category_item_id"
      end
    end
  end
end
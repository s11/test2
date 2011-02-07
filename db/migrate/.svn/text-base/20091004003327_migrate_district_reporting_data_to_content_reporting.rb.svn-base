#--
#  20091004003327_migrate_district_reporting_data_to_content_reporting.rb
#  management
#  
#  Created by John Meredith on 2009-10-04.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class MigrateDistrictReportingDataToContentReporting < ActiveRecord::Migration
  def self.up
    # Insert the districts
    execute "REPLACE INTO districts (id, name, created_at, updated_at, deleted_at) SELECT id, name, created_at, updated_at, deleted_at FROM district_reporting.districts"
    execute "REPLACE INTO clients_districts (district_id, client_id) SELECT ds.district_id, c.id FROM district_reporting.districts_schools AS ds INNER JOIN clients AS c ON c.client_prefix=ds.school_id"
  end

  def self.down
    execute "TRUNCATE districts"
    execute "TRUNCATE clients_districts"
  end
end

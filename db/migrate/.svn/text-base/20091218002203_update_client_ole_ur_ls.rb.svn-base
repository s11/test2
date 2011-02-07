#--
#  20091218002203_update_client_ole_ur_ls.rb
#  management
#  
#  Created by John Meredith on 2009-12-18.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class UpdateClientOleUrLs < ActiveRecord::Migration
  def self.up
    execute "UPDATE clients SET client_spare3=REPLACE(client_spare3, 'cartman.cdxplus.com', 'cdxplus.com')"
    execute "UPDATE clients SET client_ole_url=REPLACE(client_ole_url, 'cartman.cdxplus.com', 'cdxplus.com')"
  end

  def self.down
    execute "UPDATE clients SET client_ole_url=REPLACE(client_ole_url, 'cdxplus.com', 'cartman.cdxplus.com')"
    execute "UPDATE clients SET client_spare3=REPLACE(client_spare3, 'cdxplus.com', 'cartman.cdxplus.com')"
  end
end

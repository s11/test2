#--
#  20091218001716_change_allowed_urls_default.rb
#  management
#  
#  Created by John Meredith on 2009-12-18.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class ChangeAllowedUrlsDefault < ActiveRecord::Migration
  def self.up
    change_column_default :clients, :client_spare4, '+cdxplus.com,+javascript:,+about:blank,'
  end

  def self.down
    change_column_default :clients, :client_spare4, '+cartman.cdxplus.com,+javascript:,+about:blank,'
  end
end

#--
#  menu_versions_controller.rb
#  management
#  
#  Created by John Meredith on 2009-10-11.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class Api::MenuVersionsController < ApiController
  defaults :resource_class => MenuVersion, :collection_name => :versions
  actions :all
  belongs_to :menu
end

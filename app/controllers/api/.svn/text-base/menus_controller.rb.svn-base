#--
#  menus_controller.rb
#  management
#  
#  Created by John Meredith on 2009-09-18.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class Api::MenusController < ApiController
  defaults :resource_class => Menu
  actions :all

  protected
    # Overridden from ApiController to include supervisor details
    def search_results
      @search_results ||= search.paginate(:include => :versions, :page => page, :per_page => per_page)
    end

    # Include the supervisor details when fetching clients
    def serialization_options
      { :include => { :versions => { :except => [ :created_at, :updated_at, :deleted_at, :lock_version ]}}, :except => [ :created_at, :updated_at, :deleted_at, :lock_version ]}
    end
end

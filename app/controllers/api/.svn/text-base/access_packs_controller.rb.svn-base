#--
#  access_packs_controller.rb
#  management
#  
#  Created by John Meredith on 2010-01-31.
#  Copyright 2010 CoRoam. All rights reserved.
#++
class Api::AccessPacksController < ApiController
  defaults :resource_class => AccessPack
  actions :index, :count, :assign_range

  belongs_to :client


  def assign_range
    build_resource

    if @client.assign_access_packs(params[:start_id], params[:finish_id])
      head :reset_content
    else
      head :conflict
    end
  end

  protected
    # Overridden from ApiController to include user details
    def search_results
      @search_results ||= search.paginate(:include => :user, :page => page, :per_page => per_page)
    end

    # Allow custom options when serialising records ie. :include => :some_associated_object
    def serialization_options
      { :include => :user }
    end

end
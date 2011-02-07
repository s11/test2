#--
#  api_controller.rb
#  management
#  
#  Created by John Meredith on 2009-09-14.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class ApiController < ActionController::Base
  # Include InhertiedResources instead of inheriting as we don't want the overhead of ApplicatonController's HTML processing
  inherit_resources

  
  respond_to :xml, :json
  actions :all


  # All API calls return XML or JSON. No layout required.
  layout nil


  # We override this to allow for serialization options in subclassed controllers
  def index
    index! do |success|
      success.xml   { render :xml  => collection.to_xml(serialization_options) }
      success.json  { render :json => collection.to_json(serialization_options) }
    end
  end

  # We override this to allow for serialization options in subclassed controllers
  def show
    show! do |success|
      success.xml   { render :xml  => resource.to_xml(serialization_options) }
      success.json  { render :json => resource.to_json(serialization_options) }
    end
  end

  # Returns the total number of records for the given resource
  def count
    render :template => 'api/count'
  end


  protected
    # Limit the collection to the given search parameters
    def search
      @search ||= end_of_association_chain.searchlogic(params[:search])
    end
    helper_method :search

    # Returns the results of the search query. Override in subclassed controllers to add joins etc.
    def search_results
      @search_results ||= search.paginate(:page => page, :per_page => per_page)
    end

    # Returns the total number of resources
    def total_count
      @total_count ||= search.count
    end
    helper_method :total_count

    # Override the default collection to include pagination
    def collection
      get_collection_ivar || set_collection_ivar(search_results)
    end

    # Allow custom options when serialising records ie. :include => :some_associated_object
    def serialization_options
      {}
    end

    
  private
    # Returns the requested page. Default to the first.
    def page
      params[:page].present? ? params[:page].to_i : 1
    end

    # Returns the requested number of records requested. Defaults to 20.
    def per_page
      params[:per_page].present? ? params[:per_page].to_i : 20
    end
end

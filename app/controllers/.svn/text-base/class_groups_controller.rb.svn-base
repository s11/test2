#--
#  class_groups_controller.rb
#  management
#  
#  Created by John Meredith on 2009-07-27.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class ClassGroupsController < InheritedResources::Base
  respond_to :html


  before_filter :build_resource,  :only => [:index, :create]
  before_filter :collection,      :only => [:index, :create]


  def create
    create! do |success, failure|
      success.html { redirect_to edit_class_group_path(resource) }
      failure.html { render :action => "index" }
    end
  end

  # Makes a copy of the given resource
  def copy
    class_group = resource.clone
    class_group.name += " (Copy)"
    class_group.user_ids = resource.user_ids.clone
    class_group.save!

    redirect_to edit_class_group_path(class_group)
  end

  def update
    resource.user_ids = params[:class_group].delete(:users) {|k| {}}.map(&:to_i)
    update! { params.has_key?(:saveandcopy) ? copy_class_group_path(resource) : class_groups_path }
  end

  # PUT /messages/bulk_update
  def bulk_update
    ClassGroup.destroy_all({ :id => params[:resource_ids].keys, :client_id => current_client.id }) if params[:resource_ids].present?
    redirect_to :back
  end

  protected
    # Only class groups from the current user's client
    def begin_of_association_chain
      current_client
    end

    def collection
      @search       ||= end_of_association_chain.searchlogic(params[:search])
      @class_groups ||= @search.paginate(:page => params[:page], :per_page => params[:per_page])
    end
end

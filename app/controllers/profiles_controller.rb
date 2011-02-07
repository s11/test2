#--
#  profiles_controller_controller.rb
#  management
#  
#  Created by John Meredith on 2009-07-23.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class ProfilesController < InheritedResources::Base
  # InheritedResource config
  defaults :singleton => true, :resource_class => User, :instance_name => :user
  respond_to :html
  actions :show, :edit, :update, :update_video_size_profile


  # Simple hack to render the edit
  def show
    render :action => "edit"
  end

  def update
    resource.class_group_ids = params[:user].delete(:class_groups) {|k| {}}.map(&:to_i)
    update! do |success, failure|
      success.html do
        redirect_to profile_path
      end
    end
  end


  # PUT /user/:id/change_video_size_user
  def update_video_size
    current_user.update_attributes(:video_size => params[:user][:video_size])
    redirect_to :back
  end

  protected
    # The resource is always the currently logged in user
    def resource
      current_user
    end

    
  add_breadcrumb "Your Profile", 'profile_path'
end

#--
#  accounts_controller.rb
#  management
#  
#  Created by John Meredith on 2009-07-22.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class AccountsController < InheritedResources::Base
  # InheritedResource config
  defaults :singleton => true, :resource_class => Client, :instance_name => :client
  respond_to :html
  actions :show, :edit, :update


  # Breadcrumbs
  add_breadcrumb "Account Details", 'account_path'


  # The default is to edit the profile
  def show
    render :action => "edit"
  end


  def update
    update!

    # Update the NATEF certified areas which need to be handlded differently
    if current_client.menu.name =~ /ASE/
      resource.natef_certified_areas.destroy_all
      if params[:natef_certified_areas].present?
        params[:natef_certified_areas].each_pair do |description, value|
          nca = current_client.natef_certified_areas.find_or_initialize_by_version_and_description(current_client.preferred_natef_version, description)
          nca.save!
        end
      end
    end
  end

  protected
    # The "account" in this context is the current client. Make sure we force that.
    def resource
      current_client
    end
end

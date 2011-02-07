#--
#  users_controller.rb
#  management
#  
#  Created by John Meredith on 2009-06-27.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
require 'fastercsv'

class UsersController < InheritedResources::Base
  # The following forces InheritedResources to use User or it'll try to get Students / Instructors instead due to defined routes
  defaults :resource_class => User, :instance_name => :user, :collection_name => :users


  has_scope :by_role, :key => :role


  respond_to :html
  respond_to :csv, :json, :only => :index


  helper_method :build_resource

  # We need to assign the class groups manually
  def create
    class_group_ids = params[:user].delete(:class_groups) {|k| {}}.map(&:to_i) 

    create! do |success, failure|
      success.html do
        resource.class_group_ids = class_group_ids
        resource.save

        redirect_to url_for(:controller => "users", :action => "index", :role => resource.role)
      end
    end
  end

  def index
    index! do |format|
      format.csv do 
        csv_filename = "#{current_client.client_prefix}_#{current_role.pluralize}_#{DateTime.now.to_formatted_s(:number)}.csv"
        report       = search.report_table(:all, :only => [ :id, :username, :firstname, :lastname, :email, :year_level, :course_idnumber, :student_id, :menu_name ])
        report.add_column('class_groups') do |t|
          current_client.users.find(t['id']).class_groups.all(:select => :name).map(&:name) * ', '
        end
        report.remove_column('id')

        send_data(report.to_csv, :filename => csv_filename, :type => "text/csv", :disposition => "attachment")
      end
    end
  end

  # Just for the crumbs
  def show
    add_breadcrumb "User Management", users_path(:role => params[:role])
    add_breadcrumb resource.fullname, resource
  end

  # Just for the crumbs
  def edit
    add_breadcrumb "User Management", users_path(:role => params[:role])
    add_breadcrumb "Editing #{resource.fullname}", edit_user_path(resource)
  end

  def update
    resource.class_group_ids = params[:user].delete(:class_groups) {|k| {}}.map(&:to_i)
    update! { url_for(:controller => "users", :action => "index", :role => resource.role) }
  end

  # Will mass assign users to a particular menu
  def bulk_update
    # Only do something if we have some IDs
    if params[:user_ids].present?
      if params.has_key?(:update)
        if params[:menu_version_id].blank?
          current_client.send(current_role.pluralize).update_all( 'menu_version_id=NULL', "id IN (#{ params[:user_ids] * ',' })" )
        else
          current_client.send(current_role.pluralize).update_all( "menu_version_id=#{params[:menu_version_id]}", "id IN (#{ params[:user_ids] * ',' })" ) if MenuVersion.exists?(params[:menu_version_id])
        end
      elsif params.has_key?(:delete)
        # Unfortunately, ActiveRecord won't support destroy_all with conditions on scopes. Do it manually ensuring we have the correct client and role.
        User.destroy_all(:client_id => current_client, :role_shortname => current_role, :id => params[:user_ids])
        flash[:notice] = "#{params[:user_ids].size} selected #{current_role.pluralize} permanently deleted."
      end
    end

    redirect_to :back
  end

  def destroy
    destroy! { url_for(:action => "index", :role => resource.role) }
  end

  protected
    # Users are always associated with a client. Make sure InheritedResources uses the current_client.
    alias_method :begin_of_association_chain, :current_client
    
    def current_role
      @role ||= params[:role] || 'student'
    end
    helper_method :current_role

    def search
      return @search if defined?(@search)

      @search = end_of_association_chain.searchlogic(params[:search])
      @search.role_shortname = current_role
      @search
    end

    # We want to take advantage of searchlogic, so override the collection method.
    def collection
      @users  ||= search.paginate(:all, :include => [:menu_version, :class_groups], :page => params[:page], :per_page => params[:per_page])
    end
end

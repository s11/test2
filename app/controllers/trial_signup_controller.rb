# 
# trial_signup_controller.rb
# online
# 
# Created by John Meredith on 2008-08-19.
# Copyright 2008 CDX Global. All rights reserved.
# 
# Signup form the trial requests. Initially for the Pearson (atp1) trial site.
# 
class TrialSignupController < ApplicationController
  # This is hard-coded to 'atp1' for the moment. No doubt they'll want everyone to have this trial request facility in the future.
  CLIENT_PREFIX = 'atp1'

  before_filter :initialise_environment

  # GET /trial_signup
  def index
    @user = User.new(:country => 'United States')
  end

  # POST /trial_signup
  def create
    @user             = current_client.users.build(params[:cdx_user])
    @user.email       = params[:cdx_user][:email].strip
    @user.city        = params[:cdx_user][:city].strip
    @user.institution = params[:cdx_user][:institution].strip
    @user.spare_text  = params[:repcode].strip
    @user.deleted_at  = 14.days.from_now

    if PearsonSalesRep.exists?(:code => params[:repcode])
      # Manually generate password
      @user.unencrypted_password = @user.unencrypted_password_confirmation = generate_password(@user.username)

      # Make sure we're not duping the email address
      respond_to do |format|
        if current_client.users.find_with_deleted(:first, :conditions => {:email => @user.email})
          flash[:error] = "The email specified has already been registered for a trial logon."
          format.html { render :action => :index }
          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        elsif (@user.spare_text.blank? || @user.email.blank? || @user.city.blank? || @user.institution.blank? || !@user.valid?)
          flash[:error] = "Please ensure all field have been completed."
          format.html { render :action => :index }
          format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        else
          @user.save

          ApplicationMailer.deliver_pearson_trial_signup_notification(@user)

          flash[:success] = "#{@user.role_shortname.titleize} was successfully created."
          format.html { render :action => :thanks }
          format.xml  { render :xml => @user, :status => :created, :location => @user }
        end
      end
    else
      respond_to do |format|
        flash[:error] = "The representative code could not be found."
        format.html { render :action => :index }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update_regions
    respond_to do |wants|
      wants.js do
        render :update do |page|
          select_options = country_region_option_groups_for_select(Country.find_by_name(params[:country]))

          # Region selection depends on whether the country has some
          if select_options.blank?
            page.hide('region')
          else
            page.show('region')
          end

          page.replace_html 'cdx_user_state', select_options
        end
      end
    end
  end
  
  protected
    # Return the client for the current request
    def current_client
      @client ||= Client.find(params[:client_prefix] || CLIENT_PREFIX)
    end

    #
    # We need to adjust the client user table and moodle database on every request.
    #
    def initialise_environment
      # Make sure we're pointing to the correct user database
      User.set_table_name("cdxenroldb_v4.#{current_client.client_table}")

      # Make sure we're talking to the correct moodle database
      Moodle::Base.setup_tables_by_database(current_client.client_database_name)
    end

  private
    def generate_password(login)
      Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--")[0,10]
    end
end

# 
#  application.rb
#  online
#  
#  Created by John Meredith on 2008-02-16.
#  Copyright 2008 CDX Global. All rights reserved.
# 
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
#
class ApplicationController < ActionController::Base
  before_filter :require_user
  before_filter :set_moodle_database
  before_filter :set_time_zone
  before_filter :require_current_terms_and_conditions_acceptance
  before_filter :add_home_breadcrumb
  after_filter  :close_last_activity_log_entry


  helper :all
  helper_method :current_user_session, :current_user, :current_client, :current_menu, :current_menu_version, :access_agent


  # See ActionController::RequestForgeryProtection for details. Uncomment the :secret if you're not using the cookie session store.
  protect_from_forgery


  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation



  protected
      # Add a breadcrumb to the trail
    def add_breadcrumb(name, url = '')
      @breadcrumbs ||= []
      url = eval(url) if url =~ /_path|_url|@/
      @breadcrumbs << [name, url]
    end

    # Class method to add a breadcrumb to the trail. Uses before_filter so
    # options such as :only and :except will be applied.
    def self.add_breadcrumb(name, url, options = {})
      before_filter options do |controller|
        controller.send(:add_breadcrumb, name, url)
      end
    end



  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end

    def current_menu
      current_user.menu if current_user
    end

    def current_menu_version
      current_user.menu_version if current_user
    end

    def current_client
      return @current_client if defined?(@current_client)
      @current_client = current_user.try(:client)
    end

    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to login_url
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to root_path
      end
    end

    def require_current_terms_and_conditions_acceptance
      unless current_user && current_user.accepted_latest_terms_and_conditions?
        store_location
        redirect_to new_terms_and_conditions_acceptance_path
      end
    end

    def store_location
      session[:return_to] = request.request_uri
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    # Ensure we always display the home page link
    def add_home_breadcrumb
      add_breadcrumb "Dashboard", 'root_path' if current_user
    end

    # Ensure the Moodle database is set
    def set_moodle_database
      current_client && Moodle::Base.setup_tables_by_client(current_client)
    end

    # Sets the time zone for the request. Defaults to "Pacific Time (US & Canada)"
    def set_time_zone
      Time.zone = current_user && current_user.time_zone
    end

    # Close the last activity log entry
    def close_last_activity_log_entry
      return unless current_user

      if last_entry = current_user.activity_logs.first(:conditions => ["closed_at IS NULL AND login_at=?", current_user.current_login_at], :order => "opened_at DESC")
        last_entry.update_attributes!(:closed_at => DateTime.now)
      end
    end
    
    # Check who's accessing the site
    def access_agent
      (request.headers['HTTP_USER_AGENT'].match(/CDXOnlineClient Ver/).nil? ? :browser : :launcher )
    end
end

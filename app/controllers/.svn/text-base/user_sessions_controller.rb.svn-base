#--
#  user_sessions_controller.rb
#  management
#  
#  Created by John Meredith on 2009-07-12.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class UserSessionsController < ApplicationController
  before_filter       :require_no_user, :only => [:new, :create]
  before_filter       :require_user,    :only => :destroy
  skip_before_filter  :require_current_terms_and_conditions_acceptance

  # Login
  def new
    @user_session = UserSession.new
  end

  # Login
  def create
    @user_session = UserSession.new
    if Client.exists?(:client_prefix => params[:client_prefix].downcase)
      @user_session = Client.find_by_client_prefix!(params[:client_prefix].downcase).user_sessions.new(params[:user_session])
      if @user_session.save
        flash[:notice] = "Login successful!"
        redirect_back_or_default (params[:redirect_uri] || root_path)
      else
        flash[:notice] = "Invalid login details!"
        render :action => :new
      end
    else
      flash[:notice] = "Invalid login details!"
      render :action => :new
    end
  end

  # Logout
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default login_path
  end
  
end

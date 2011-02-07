#
# Access Pack Controller: handles the redemption of JBP usecodes and the creation of cdx users when a valid code
# Author: paul meyerle
# Date: 12.05.2009
#

class AccessPacksController < ActionController::Base
  # use the same layout as the login/logout
  layout 'user_sessions'
  
  skip_before_filter :require_user

  def new
    @title = "CDX Registration Code Redemption"
  end

  # custom create action
  def create 
    if client 
      # see if there are user errors
      if !user.valid?
        error user.errors.full_messages * "<br />"
      else
        #user/client info is correct, now check the access code if that passes then create the user
        if Mssql::JbpAccessCode.valid_code?(params[:user].andand[:jbp_access_code])
          #code was valid, email user if email was supplied and redirect to the instructions page.
          # save the new user to the database
          user.save!            

          # redeem the code          
          if Mssql::JbpAccessCode.redeem_code(params[:user].andand[:jbp_access_code], user) 
            # redirect user to the 'download cdx launcher url'
            # redirect_to "http://www.cdxglobal.com/launcher/index.html"
            # redirect to login page
            redirect_to login_path            
          else
            # if the redemption fails then destroy the newly created user, this wont delete it from the database, just sets 
            # the deleted_at field to the current date.
            user.destroy
            error "Error while redeeming the use code"
          end
        else
          #invalid use code
          error "Invalid registration code. Please re-enter the code carefully."
        end
      end
    else
      # client wasn't found
      error 'Invalid Access Code'
    end
  end

  private
    # member variabl which returns the client
    def client
      # try and find the client based on school code aka client_prefix
      @client ||= Client.find_by_client_prefix(params[:client].andand[:client_prefix])
    end

    # member variable which returns the user
    def user
      return @user if defined?(@user)
      @user = client.students.new(params[:user])
      @user.deleted_at = client.access_pack_lifetime.from_now
      @user
    end

    # prints the inputed msg to the flash and then renders the redemption form
    def error msg
      flash[:notice] = msg
      render :action => :new
    end

end

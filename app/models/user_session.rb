#--
#  user_session.rb
#  management
#  
#  Created by John Meredith on 2009-07-12.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class UserSession < Authlogic::Session::Base
  logout_on_timeout true
  remember_me false


  after_create    :change_persistence_token, :assign_moodle_session_password
  before_destroy  :clear_moodle_session_password

  
  attr_reader :moodle_password


  private
    # We want to limit to one session per user. Do this by resetting the persistence token when someone logs in.
    def change_persistence_token
      record.reset_persistence_token
    end

    # Create a new password for the associated moodle user and store the cleartext in the session for later use
    def assign_moodle_session_password
      controller.session[:moodle_password] = ActiveSupport::SecureRandom.base64(16)
      record.moodle_session_password       = Digest::MD5.hexdigest( controller.session[:moodle_password] )
    end
    
    # Clear out the moodle session password / token for the user when the session is destroyed. No need to explictly save ... 
    # authlogic will do that anyway.
    def clear_moodle_session_password
      record.moodle_session_password = nil
    end
end
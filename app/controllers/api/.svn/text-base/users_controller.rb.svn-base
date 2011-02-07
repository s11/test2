#--
#  users_controller.rb
#  management
#  
#  Created by John Meredith on 2009-09-18.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class Api::UsersController < ApiController
  defaults :resource_class => User
  belongs_to :client

  protected
    # Include the supervisor details when fetching clients
    def serialization_options
      { :except => [ :crypted_password, :lock_version, :persistence_token, :single_access_token, :perishable_token, :moodle_session_password ]}
    end
  
end

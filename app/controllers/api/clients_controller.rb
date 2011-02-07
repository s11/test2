#--
#  clients_controller.rb
#  management
#  
#  Created by John Meredith on 2009-09-14.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class Api::ClientsController < ApiController
  defaults :resource_class => Client
  # optional_belongs_to :district


  before_filter :remove_supervisor_details, :only => :create


  def create
    create! do |success, failure|
      supervisor = resource.users.build(
        :username              => 'supervisor',
        :password              => resource.cleartext_password,
        :password_confirmation => resource.cleartext_password,
        :role_shortname        => 'supervisor',
        :firstname             => supervisor_firstname,
        :lastname              => supervisor_lastname,
        :email                 => resource.email
      )
      supervisor.save!
    end
  end

  def update
    # Strip out the supervisor details
    supervisor_parameters = params[:client].delete(:supervisor)

    update! do
      # ...and make sure we update the supervisor with the above details
      supervisor = resource.supervisor
      supervisor.update_attributes(supervisor_parameters)
      supervisor.password              = resource.cleartext_password
      supervisor.password_confirmation = resource.cleartext_password
      supervisor.save
    end
  end

  protected
    # Overridden from ApiController to include supervisor details
    def search_results
      @search_results ||= search.paginate(:include => :supervisor, :page => page, :per_page => per_page)
    end

    # Include the supervisor details when fetching clients
    def serialization_options
      { :include => { :supervisor => { :except => [ :crypted_password, :lock_version, :persistence_token, :single_access_token, :perishable_token, :moodle_session_password ]}}, :except => :lock_version }
    end

    def supervisor_firstname
      @supervisor_firstname ||= params[:client].delete(:supervisor_firstname)
    end

    def supervisor_lastname
      @supervisor_lastname ||= params[:client].delete(:supervisor_lastname)
    end

    # Strip the supervisor details from the client request params. They need to be used separately.
    def remove_supervisor_details
      supervisor_firstname and supervisor_lastname
    end
end

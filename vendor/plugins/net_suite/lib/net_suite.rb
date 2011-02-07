# 
#  net_suite.rb
#  administration
#  
#  Created by John Meredith on 2008-11-24.
#  Copyright 2008 CDX Global. All rights reserved.
# 
gem 'soap4r'
require "net_suite/soap/default_driver"
require "net_suite/filters"

module NetSuite
  module Roles
    ADMINISTRATOR = returning(NetSuite::SOAP::RecordRef.new) do |ref|
      ref.xmlattr_internalId = 3
    end
  end


  module Helpers
    # Created a custom date field reference for NS. Used in customFieldLists.
    def self.custom_date_field_ref(internalId, value)
      record = NetSuite::SOAP::DateCustomFieldRef.new(value)
      record.xmlattr_internalId = internalId.to_s
      record
    end

    # Created a custom string field reference for NS. Used in customFieldLists.
    def self.custom_string_field_ref(internalId, value)
      record = NetSuite::SOAP::StringCustomFieldRef.new(value)
      record.xmlattr_internalId = internalId.to_s
      record
    end

    # Created a custom long/integer field reference for NS. Used in customFieldLists.
    def self.custom_long_field_ref(internalId, value)
      record = NetSuite::SOAP::LongCustomFieldRef.new(value)
      record.xmlattr_internalId = internalId.to_s
      record
    end
  end

  
  class << self
    # NetSuite passport authentication details
    attr_accessor :passport_email, :passport_password, :passport_account, :passport_role

    # Call this method to modify defaults in your initializers ie.
    #
    # NetSuite.configure do |config|
    #   config.passport_email = "someone@somewhere.com"
    # end
    #
    def configure
      yield self
    end
  
    # The NetSuite session / SOAP driver
    def session
      @session ||= returning(NetSuite::SOAP::NetSuitePortType.new) do |sess|
        sess.proxy.streamhandler.client.ssl_config.verify_mode = nil          # We don't want to validate the SSL cert. Assume valid :-)
        sess.wiredump_dev = STDOUT if Rails.env.development?
      end
    end

    # Returns true if we already have a NetSuite session
    def session_exists?
      !!@session
    end

    # Returns true if we're logged in
    def logged_in?
      @logged_in ||= false
      @logged_in
    end

    # Wraps the given controller (and action) with a NetSuite session. For use
    # with +ActionController::Filters.around_filter+
    def filter(controller, &block)
      login
      yield session
    ensure    # Make sure we logout irrespective
      logout
    end
    
    private
      # Returns a NetSuite::SOAP::Passport object
      def passport
        @passport ||= NetSuite::SOAP::Passport.new(passport_email, passport_password, passport_account, passport_role)
      end

      # Need to specify the role of the user logging in, specifically if the
      # user has multiple roles.
      def passport_role
        (role = NetSuite::SOAP::RecordRef.new).xmlattr_internalId = 3
        role
      end

      # Login to NetSuite and return true if successful
      def login
        unless @logged_in
          print "[NetSuite] Not logged in. Attempting to login to NetSuite [#{logged_in?}] now..."

          request   = NetSuite::SOAP::LoginRequest.new(passport)
          response  = session.login(request)

          if response.sessionResponse.status.xmlattr_isSuccess
            @logged_in = true
            print "done\n"
          else
            print "failed\n"
          end
        else
          print "[NetSuite] Already logged in\n"
          return false
        end
      end
    
      # Logout from NetSuite and return true if successful
      def logout
        if @logged_in
          print "[NetSuite] Attempting to log out..."
          request   = NetSuite::SOAP::LogoutRequest.new
          response  = session.logout(request)

          if response.sessionResponse.status.xmlattr_isSuccess
            @logged_in = false
            print "done\n"
          else
            print "failed\n"
          end
          
          return response.sessionResponse.status.xmlattr_isSuccess
        else
          print "[NetSuite] Not logged in. Can't log out.\n"
          return false
        end
      end
  end
end

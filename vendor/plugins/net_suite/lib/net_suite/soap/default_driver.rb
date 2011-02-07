# 
#  default_driver.rb
#  administration
#  
#  Created by John Meredith on 2008-11-24.
#  Copyright 2008 CDX Global. All rights reserved.
# 
require 'net_suite/soap/default.rb'
require 'net_suite/soap/default_mapping_registry.rb'
require 'soap/rpc/driver'

module NetSuite
  module SOAP
    class NetSuitePortType < ::SOAP::RPC::Driver
      DefaultEndpointUrl = "https://webservices.netsuite.com/services/NetSuitePort_2008_1"

      Methods = [
        [ "login",
          "login",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "login"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "loginResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::InvalidVersionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidVersionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidAccountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidAccountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidCredentialsFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidCredentialsFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InsufficientPermissionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InsufficientPermissionFault", :encodingstyle=>"document"}} }
        ],
        [ "mapSso",
          "mapSso",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "mapSso"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "mapSsoResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::InvalidVersionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidVersionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidAccountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidAccountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidCredentialsFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidCredentialsFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InsufficientPermissionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InsufficientPermissionFault", :encodingstyle=>"document"}} }
        ],
        [ "changePasswordOrEmail",
          "changePasswordOrEmail",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "changePasswordOrEmail"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "changePasswordOrEmailResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::InvalidVersionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidVersionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidAccountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidAccountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidCredentialsFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidCredentialsFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InsufficientPermissionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InsufficientPermissionFault", :encodingstyle=>"document"}} }
        ],
        [ "logout",
          "logout",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "logout"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "logoutResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}} }
        ],
        [ "add",
          "add",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "add"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "addResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::ExceededRequestSizeFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestSizeFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRecordCountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRecordCountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRequestLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestLimitFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededUsageLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededUsageLimitFault", :encodingstyle=>"document"}} }
        ],
        [ "delete",
          "delete",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "delete"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "deleteResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::ExceededRequestSizeFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestSizeFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRecordCountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRecordCountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRequestLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestLimitFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededUsageLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededUsageLimitFault", :encodingstyle=>"document"}} }
        ],
        [ "search",
          "search",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "search"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "searchResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::ExceededRequestSizeFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestSizeFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRecordCountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRecordCountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRequestLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestLimitFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededUsageLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededUsageLimitFault", :encodingstyle=>"document"}} }
        ],
        [ "searchMore",
          "searchMore",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "searchMore"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "searchMoreResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::ExceededRequestSizeFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestSizeFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRecordCountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRecordCountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRequestLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestLimitFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededUsageLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededUsageLimitFault", :encodingstyle=>"document"}} }
        ],
        [ "searchNext",
          "searchNext",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "searchNext"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "searchNextResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::ExceededRequestSizeFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestSizeFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRecordCountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRecordCountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRequestLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestLimitFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededUsageLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededUsageLimitFault", :encodingstyle=>"document"}} }
        ],
        [ "update",
          "update",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "update"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "updateResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::ExceededRequestSizeFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestSizeFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRecordCountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRecordCountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRequestLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestLimitFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededUsageLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededUsageLimitFault", :encodingstyle=>"document"}} }
        ],
        [ "addList",
          "addList",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "addList"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "addListResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::ExceededRequestSizeFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestSizeFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRecordCountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRecordCountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRequestLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestLimitFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededUsageLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededUsageLimitFault", :encodingstyle=>"document"}} }
        ],
        [ "deleteList",
          "deleteList",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "deleteList"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "deleteListResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::ExceededRequestSizeFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestSizeFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRecordCountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRecordCountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRequestLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestLimitFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededUsageLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededUsageLimitFault", :encodingstyle=>"document"}} }
        ],
        [ "updateList",
          "updateList",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "updateList"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "updateListResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::ExceededRequestSizeFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestSizeFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRecordCountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRecordCountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRequestLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestLimitFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededUsageLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededUsageLimitFault", :encodingstyle=>"document"}} }
        ],
        [ "get",
          "get",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "get"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "getResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::ExceededRequestSizeFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestSizeFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRecordCountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRecordCountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRequestLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestLimitFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededUsageLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededUsageLimitFault", :encodingstyle=>"document"}} }
        ],
        [ "getList",
          "getList",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "getList"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "getListResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::ExceededRequestSizeFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestSizeFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRecordCountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRecordCountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRequestLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestLimitFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededUsageLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededUsageLimitFault", :encodingstyle=>"document"}} }
        ],
        [ "getAll",
          "getAll",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "getAll"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "getAllResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::ExceededRequestSizeFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestSizeFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRecordCountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRecordCountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRequestLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestLimitFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededUsageLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededUsageLimitFault", :encodingstyle=>"document"}} }
        ],
        [ "getCustomization",
          "getCustomization",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "getCustomization"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "getCustomizationResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::ExceededRequestSizeFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestSizeFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRecordCountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRecordCountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRequestLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestLimitFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededUsageLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededUsageLimitFault", :encodingstyle=>"document"}} }
        ],
        [ "initialize",
          "initialize",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "initialize"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "initializeResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::ExceededRequestSizeFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestSizeFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRequestLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestLimitFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRecordCountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRecordCountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededUsageLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededUsageLimitFault", :encodingstyle=>"document"}} }
        ],
        [ "initializeList",
          "initializeList",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "initializeList"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "initializeListResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::ExceededRequestSizeFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestSizeFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRequestLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestLimitFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRecordCountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRecordCountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededUsageLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededUsageLimitFault", :encodingstyle=>"document"}} }
        ],
        [ "getSelectValue",
          "getSelectValue",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "getSelectValue"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "getSelectValueResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::ExceededRequestSizeFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestSizeFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRecordCountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRecordCountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRequestLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestLimitFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededUsageLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededUsageLimitFault", :encodingstyle=>"document"}} }
        ],
        [ "getItemAvailability",
          "getItemAvailability",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "getItemAvailability"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "getItemAvailabilityResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::ExceededRequestSizeFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestSizeFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRecordCountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRecordCountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRequestLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestLimitFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededUsageLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededUsageLimitFault", :encodingstyle=>"document"}} }
        ],
        [ "attach",
          "attach",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "attach"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "attachResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::ExceededRequestSizeFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestSizeFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRecordCountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRecordCountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRequestLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestLimitFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededUsageLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededUsageLimitFault", :encodingstyle=>"document"}} }
        ],
        [ "detach",
          "detach",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "detach"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "detachResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::ExceededRequestSizeFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestSizeFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRecordCountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRecordCountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRequestLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestLimitFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededUsageLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededUsageLimitFault", :encodingstyle=>"document"}} }
        ],
        [ "asyncAddList",
          "asyncAddList",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "asyncAddList"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "asyncAddListResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::ExceededRequestSizeFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestSizeFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRecordCountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRecordCountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}} }
        ],
        [ "asyncUpdateList",
          "asyncUpdateList",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "asyncUpdateList"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "asyncUpdateListResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::ExceededRequestSizeFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestSizeFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRecordCountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRecordCountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}} }
        ],
        [ "asyncDeleteList",
          "asyncDeleteList",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "asyncDeleteList"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "asyncDeleteListResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::ExceededRequestSizeFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestSizeFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRecordCountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRecordCountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}} }
        ],
        [ "asyncGetList",
          "asyncGetList",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "asyncGetList"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "asyncGetListResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::ExceededRequestSizeFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestSizeFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRecordCountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRecordCountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}} }
        ],
        [ "asyncInitializeList",
          "asyncInitializeList",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "asyncInitializeList"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "asyncInitializeListResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::ExceededRequestSizeFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestSizeFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRequestLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestLimitFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRecordCountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRecordCountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededUsageLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededUsageLimitFault", :encodingstyle=>"document"}} }
        ],
        [ "asyncSearch",
          "asyncSearch",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "asyncSearch"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "asyncSearchResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::ExceededRequestSizeFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestSizeFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRecordCountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRecordCountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}} }
        ],
        [ "getAsyncResult",
          "getAsyncResult",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "getAsyncResult"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "getAsyncResultResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::ExceededRequestSizeFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestSizeFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRecordCountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRecordCountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRequestLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestLimitFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}, "NetSuite::SOAP::AsyncFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"AsyncFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededUsageLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededUsageLimitFault", :encodingstyle=>"document"}} }
        ],
        [ "checkAsyncStatus",
          "checkAsyncStatus",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "checkAsyncStatus"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "checkAsyncStatusResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}, "NetSuite::SOAP::AsyncFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"AsyncFault", :encodingstyle=>"document"}} }
        ],
        [ "getDeleted",
          "getDeleted",
          [ ["in", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "getDeleted"]],
            ["out", "parameters", ["::SOAP::SOAPElement", "urn:messages_2008_1.platform.webservices.netsuite.com", "getDeletedResponse"]] ],
          { :request_style =>  :document, :request_use =>  :literal,
            :response_style => :document, :response_use => :literal,
            :faults => {"NetSuite::SOAP::ExceededRequestSizeFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRequestSizeFault", :encodingstyle=>"document"}, "NetSuite::SOAP::InvalidSessionFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"InvalidSessionFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededRecordCountFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededRecordCountFault", :encodingstyle=>"document"}, "NetSuite::SOAP::UnexpectedErrorFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"UnexpectedErrorFault", :encodingstyle=>"document"}, "NetSuite::SOAP::ExceededUsageLimitFault_"=>{:use=>"literal", :namespace=>nil, :ns=>"urn:platform_2008_1.webservices.netsuite.com", :name=>"ExceededUsageLimitFault", :encodingstyle=>"document"}} }
        ]
      ]

      def initialize(endpoint_url = nil)
        endpoint_url ||= DefaultEndpointUrl
        super(endpoint_url, nil)
        self.mapping_registry = DefaultMappingRegistry::EncodedRegistry
        self.literal_mapping_registry = DefaultMappingRegistry::LiteralRegistry
        init_methods
      end

      private
        def init_methods
          Methods.each do |definitions|
            opt = definitions.last
            if opt[:request_style] == :document
              add_document_operation(*definitions)
            else
              add_rpc_operation(*definitions)
              qname = definitions[0]
              name = definitions[2]
              if qname.name != name and qname.name.capitalize == name.capitalize
                ::SOAP::Mapping.define_singleton_method(self, qname.name) do |*arg|
                  __send__(name, *arg)
                end
              end
            end
          end
        end
    end
  end
end

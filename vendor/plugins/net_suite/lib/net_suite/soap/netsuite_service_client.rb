#!/usr/bin/env ruby
# 
#  netsuite_service_client.rb
#  administration
#  
#  Created by John Meredith on 2008-11-24.
#  Copyright 2008 CDX Global. All rights reserved.
# 
require 'net_suite/soap/default_driver.rb'

module NetSuite
  module SOAP
    endpoint_url = ARGV.shift
    obj = NetSuitePortType.new(endpoint_url)

    # run ruby with -d to see SOAP wiredumps.
    obj.wiredump_dev = STDERR if $DEBUG

    # SYNOPSIS
    #   login(parameters)
    #
    # ARGS
    #   parameters      LoginRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}LoginRequest
    #
    # RETURNS
    #   parameters      LoginResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}LoginResponse
    #
    # RAISES
    #   fault           InsufficientPermissionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InsufficientPermissionFault
    #   fault           InvalidAccountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidAccountFault
    #   fault           InvalidCredentialsFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidCredentialsFault
    #   fault           InvalidVersionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidVersionFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.login(parameters)

    # SYNOPSIS
    #   mapSso(parameters)
    #
    # ARGS
    #   parameters      MapSsoRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}MapSsoRequest
    #
    # RETURNS
    #   parameters      MapSsoResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}MapSsoResponse
    #
    # RAISES
    #   fault           InsufficientPermissionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InsufficientPermissionFault
    #   fault           InvalidAccountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidAccountFault
    #   fault           InvalidCredentialsFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidCredentialsFault
    #   fault           InvalidVersionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidVersionFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.mapSso(parameters)

    # SYNOPSIS
    #   changePasswordOrEmail(parameters)
    #
    # ARGS
    #   parameters      ChangePasswordOrEmailRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}ChangePasswordOrEmailRequest
    #
    # RETURNS
    #   parameters      ChangePasswordOrEmailResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}ChangePasswordOrEmailResponse
    #
    # RAISES
    #   fault           InsufficientPermissionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InsufficientPermissionFault
    #   fault           InvalidAccountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidAccountFault
    #   fault           InvalidCredentialsFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidCredentialsFault
    #   fault           InvalidVersionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidVersionFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.changePasswordOrEmail(parameters)

    # SYNOPSIS
    #   logout(parameters)
    #
    # ARGS
    #   parameters      LogoutRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}LogoutRequest
    #
    # RETURNS
    #   parameters      LogoutResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}LogoutResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.logout(parameters)

    # SYNOPSIS
    #   add(parameters)
    #
    # ARGS
    #   parameters      AddRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}AddRequest
    #
    # RETURNS
    #   parameters      AddResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}AddResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           ExceededRequestLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestLimitFault
    #   fault           ExceededUsageLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededUsageLimitFault
    #   fault           ExceededRecordCountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRecordCountFault
    #   fault           ExceededRequestSizeFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestSizeFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.add(parameters)

    # SYNOPSIS
    #   delete(parameters)
    #
    # ARGS
    #   parameters      DeleteRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}DeleteRequest
    #
    # RETURNS
    #   parameters      DeleteResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}DeleteResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           ExceededRequestLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestLimitFault
    #   fault           ExceededUsageLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededUsageLimitFault
    #   fault           ExceededRecordCountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRecordCountFault
    #   fault           ExceededRequestSizeFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestSizeFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.delete(parameters)

    # SYNOPSIS
    #   search(parameters)
    #
    # ARGS
    #   parameters      SearchRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}SearchRequest
    #
    # RETURNS
    #   parameters      SearchResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}SearchResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           ExceededRequestLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestLimitFault
    #   fault           ExceededUsageLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededUsageLimitFault
    #   fault           ExceededRecordCountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRecordCountFault
    #   fault           ExceededRequestSizeFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestSizeFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.search(parameters)

    # SYNOPSIS
    #   searchMore(parameters)
    #
    # ARGS
    #   parameters      SearchMoreRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}SearchMoreRequest
    #
    # RETURNS
    #   parameters      SearchMoreResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}SearchMoreResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           ExceededRequestLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestLimitFault
    #   fault           ExceededUsageLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededUsageLimitFault
    #   fault           ExceededRecordCountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRecordCountFault
    #   fault           ExceededRequestSizeFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestSizeFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.searchMore(parameters)

    # SYNOPSIS
    #   searchNext(parameters)
    #
    # ARGS
    #   parameters      SearchNextRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}SearchNextRequest
    #
    # RETURNS
    #   parameters      SearchNextResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}SearchNextResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           ExceededRequestLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestLimitFault
    #   fault           ExceededUsageLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededUsageLimitFault
    #   fault           ExceededRecordCountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRecordCountFault
    #   fault           ExceededRequestSizeFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestSizeFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.searchNext(parameters)

    # SYNOPSIS
    #   update(parameters)
    #
    # ARGS
    #   parameters      UpdateRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}UpdateRequest
    #
    # RETURNS
    #   parameters      UpdateResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}UpdateResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           ExceededRequestLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestLimitFault
    #   fault           ExceededUsageLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededUsageLimitFault
    #   fault           ExceededRecordCountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRecordCountFault
    #   fault           ExceededRequestSizeFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestSizeFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.update(parameters)

    # SYNOPSIS
    #   addList(parameters)
    #
    # ARGS
    #   parameters      AddListRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}AddListRequest
    #
    # RETURNS
    #   parameters      AddListResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}AddListResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           ExceededRequestLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestLimitFault
    #   fault           ExceededUsageLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededUsageLimitFault
    #   fault           ExceededRecordCountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRecordCountFault
    #   fault           ExceededRequestSizeFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestSizeFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.addList(parameters)

    # SYNOPSIS
    #   deleteList(parameters)
    #
    # ARGS
    #   parameters      DeleteListRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}DeleteListRequest
    #
    # RETURNS
    #   parameters      DeleteListResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}DeleteListResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           ExceededRequestLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestLimitFault
    #   fault           ExceededUsageLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededUsageLimitFault
    #   fault           ExceededRecordCountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRecordCountFault
    #   fault           ExceededRequestSizeFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestSizeFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.deleteList(parameters)

    # SYNOPSIS
    #   updateList(parameters)
    #
    # ARGS
    #   parameters      UpdateListRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}UpdateListRequest
    #
    # RETURNS
    #   parameters      UpdateListResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}UpdateListResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           ExceededRequestLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestLimitFault
    #   fault           ExceededUsageLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededUsageLimitFault
    #   fault           ExceededRecordCountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRecordCountFault
    #   fault           ExceededRequestSizeFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestSizeFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.updateList(parameters)

    # SYNOPSIS
    #   get(parameters)
    #
    # ARGS
    #   parameters      GetRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}GetRequest
    #
    # RETURNS
    #   parameters      GetResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}GetResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           ExceededRequestLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestLimitFault
    #   fault           ExceededUsageLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededUsageLimitFault
    #   fault           ExceededRecordCountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRecordCountFault
    #   fault           ExceededRequestSizeFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestSizeFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.get(parameters)

    # SYNOPSIS
    #   getList(parameters)
    #
    # ARGS
    #   parameters      GetListRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}GetListRequest
    #
    # RETURNS
    #   parameters      GetListResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}GetListResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           ExceededRequestLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestLimitFault
    #   fault           ExceededUsageLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededUsageLimitFault
    #   fault           ExceededRecordCountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRecordCountFault
    #   fault           ExceededRequestSizeFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestSizeFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.getList(parameters)

    # SYNOPSIS
    #   getAll(parameters)
    #
    # ARGS
    #   parameters      GetAllRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}GetAllRequest
    #
    # RETURNS
    #   parameters      GetAllResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}GetAllResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           ExceededRequestLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestLimitFault
    #   fault           ExceededUsageLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededUsageLimitFault
    #   fault           ExceededRecordCountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRecordCountFault
    #   fault           ExceededRequestSizeFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestSizeFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.getAll(parameters)

    # SYNOPSIS
    #   getCustomization(parameters)
    #
    # ARGS
    #   parameters      GetCustomizationRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}GetCustomizationRequest
    #
    # RETURNS
    #   parameters      GetCustomizationResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}GetCustomizationResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           ExceededRequestLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestLimitFault
    #   fault           ExceededUsageLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededUsageLimitFault
    #   fault           ExceededRecordCountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRecordCountFault
    #   fault           ExceededRequestSizeFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestSizeFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.getCustomization(parameters)

    # SYNOPSIS
    #   initialize(parameters)
    #
    # ARGS
    #   parameters      InitializeRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}InitializeRequest
    #
    # RETURNS
    #   parameters      InitializeResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}InitializeResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           ExceededRecordCountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRecordCountFault
    #   fault           ExceededRequestLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestLimitFault
    #   fault           ExceededUsageLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededUsageLimitFault
    #   fault           ExceededRequestSizeFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestSizeFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.initialize(parameters)

    # SYNOPSIS
    #   initializeList(parameters)
    #
    # ARGS
    #   parameters      InitializeListRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}InitializeListRequest
    #
    # RETURNS
    #   parameters      InitializeListResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}InitializeListResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           ExceededRecordCountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRecordCountFault
    #   fault           ExceededRequestLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestLimitFault
    #   fault           ExceededUsageLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededUsageLimitFault
    #   fault           ExceededRequestSizeFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestSizeFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.initializeList(parameters)

    # SYNOPSIS
    #   getSelectValue(parameters)
    #
    # ARGS
    #   parameters      GetSelectValueRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}getSelectValueRequest
    #
    # RETURNS
    #   parameters      GetSelectValueResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}getSelectValueResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           ExceededRequestLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestLimitFault
    #   fault           ExceededUsageLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededUsageLimitFault
    #   fault           ExceededRecordCountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRecordCountFault
    #   fault           ExceededRequestSizeFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestSizeFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.getSelectValue(parameters)

    # SYNOPSIS
    #   getItemAvailability(parameters)
    #
    # ARGS
    #   parameters      GetItemAvailabilityRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}GetItemAvailabilityRequest
    #
    # RETURNS
    #   parameters      GetItemAvailabilityResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}GetItemAvailabilityResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           ExceededRequestLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestLimitFault
    #   fault           ExceededUsageLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededUsageLimitFault
    #   fault           ExceededRecordCountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRecordCountFault
    #   fault           ExceededRequestSizeFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestSizeFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.getItemAvailability(parameters)

    # SYNOPSIS
    #   attach(parameters)
    #
    # ARGS
    #   parameters      AttachRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}AttachRequest
    #
    # RETURNS
    #   parameters      AttachResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}AttachResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           ExceededRequestLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestLimitFault
    #   fault           ExceededUsageLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededUsageLimitFault
    #   fault           ExceededRecordCountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRecordCountFault
    #   fault           ExceededRequestSizeFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestSizeFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.attach(parameters)

    # SYNOPSIS
    #   detach(parameters)
    #
    # ARGS
    #   parameters      DetachRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}DetachRequest
    #
    # RETURNS
    #   parameters      DetachResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}DetachResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           ExceededRequestLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestLimitFault
    #   fault           ExceededUsageLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededUsageLimitFault
    #   fault           ExceededRecordCountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRecordCountFault
    #   fault           ExceededRequestSizeFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestSizeFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.detach(parameters)

    # SYNOPSIS
    #   asyncAddList(parameters)
    #
    # ARGS
    #   parameters      AsyncAddListRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}AsyncAddListRequest
    #
    # RETURNS
    #   parameters      AsyncStatusResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}AsyncStatusResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           ExceededRecordCountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRecordCountFault
    #   fault           ExceededRequestSizeFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestSizeFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.asyncAddList(parameters)

    # SYNOPSIS
    #   asyncUpdateList(parameters)
    #
    # ARGS
    #   parameters      AsyncUpdateListRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}AsyncUpdateListRequest
    #
    # RETURNS
    #   parameters      AsyncStatusResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}AsyncStatusResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           ExceededRecordCountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRecordCountFault
    #   fault           ExceededRequestSizeFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestSizeFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.asyncUpdateList(parameters)

    # SYNOPSIS
    #   asyncDeleteList(parameters)
    #
    # ARGS
    #   parameters      AsyncDeleteListRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}AsyncDeleteListRequest
    #
    # RETURNS
    #   parameters      AsyncStatusResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}AsyncStatusResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           ExceededRecordCountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRecordCountFault
    #   fault           ExceededRequestSizeFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestSizeFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.asyncDeleteList(parameters)

    # SYNOPSIS
    #   asyncGetList(parameters)
    #
    # ARGS
    #   parameters      AsyncGetListRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}AsyncGetListRequest
    #
    # RETURNS
    #   parameters      AsyncStatusResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}AsyncStatusResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           ExceededRecordCountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRecordCountFault
    #   fault           ExceededRequestSizeFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestSizeFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.asyncGetList(parameters)

    # SYNOPSIS
    #   asyncInitializeList(parameters)
    #
    # ARGS
    #   parameters      AsyncInitializeListRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}AsyncInitializeListRequest
    #
    # RETURNS
    #   parameters      AsyncStatusResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}AsyncStatusResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           ExceededRecordCountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRecordCountFault
    #   fault           ExceededRequestLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestLimitFault
    #   fault           ExceededUsageLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededUsageLimitFault
    #   fault           ExceededRequestSizeFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestSizeFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.asyncInitializeList(parameters)

    # SYNOPSIS
    #   asyncSearch(parameters)
    #
    # ARGS
    #   parameters      AsyncSearchRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}AsyncSearchRequest
    #
    # RETURNS
    #   parameters      AsyncStatusResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}AsyncStatusResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           ExceededRecordCountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRecordCountFault
    #   fault           ExceededRequestSizeFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestSizeFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.asyncSearch(parameters)

    # SYNOPSIS
    #   getAsyncResult(parameters)
    #
    # ARGS
    #   parameters      GetAsyncResultRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}GetAsyncResultRequest
    #
    # RETURNS
    #   parameters      GetAsyncResultResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}GetAsyncResultResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           ExceededRequestLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestLimitFault
    #   fault           ExceededUsageLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededUsageLimitFault
    #   fault           ExceededRecordCountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRecordCountFault
    #   fault           ExceededRequestSizeFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestSizeFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #   fault           AsyncFault - {urn:faults_2008_1.platform.webservices.netsuite.com}AsyncFault
    #
    parameters = nil
    puts obj.getAsyncResult(parameters)

    # SYNOPSIS
    #   checkAsyncStatus(parameters)
    #
    # ARGS
    #   parameters      CheckAsyncStatusRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}CheckAsyncStatusRequest
    #
    # RETURNS
    #   parameters      AsyncStatusResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}AsyncStatusResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           AsyncFault - {urn:faults_2008_1.platform.webservices.netsuite.com}AsyncFault
    #   fault           ExceededRequestSizeFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestSizeFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.checkAsyncStatus(parameters)

    # SYNOPSIS
    #   getDeleted(parameters)
    #
    # ARGS
    #   parameters      GetDeletedRequest - {urn:messages_2008_1.platform.webservices.netsuite.com}GetDeletedRequest
    #
    # RETURNS
    #   parameters      GetDeletedResponse - {urn:messages_2008_1.platform.webservices.netsuite.com}GetDeletedResponse
    #
    # RAISES
    #   fault           InvalidSessionFault - {urn:faults_2008_1.platform.webservices.netsuite.com}InvalidSessionFault
    #   fault           ExceededUsageLimitFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededUsageLimitFault
    #   fault           ExceededRecordCountFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRecordCountFault
    #   fault           ExceededRequestSizeFault - {urn:faults_2008_1.platform.webservices.netsuite.com}ExceededRequestSizeFault
    #   fault           UnexpectedErrorFault - {urn:faults_2008_1.platform.webservices.netsuite.com}UnexpectedErrorFault
    #
    parameters = nil
    puts obj.getDeleted(parameters)
  end
end

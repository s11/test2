# 
#  messages_controller.rb
#  online_trunk
#  
#  Created by John Meredith on 2008-04-01.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class MessagesController < InheritedResources::Base
  has_scope :by_state

  respond_to :html
  respond_to :json, :only => :recipient_list


  actions :all


  def create
    build_resource.to(extract_message_recipients_from_request)

    # Assign the user and class groups as recipients of the message and save
    create! do |success, failure|
      success.html do 
        # Deliver the message if requested
        @message.deliver! if params.has_key?("commit")
        
        redirect_to message_path(@message)
      end
    end
  end


  def update
    # Assign the user and class groups as recipients of the message and save
    resource.to(extract_message_recipients_from_request)
    update!

    # Deliver the message if requested
    @message.deliver! if params.has_key?("commit")
  end



  # Hides selected messages for the current user
  def bulk_destroy
    message_ids = params[:message_ids].keys
    current_user.messages.find_each(:conditions => { :id => message_ids }) { |m| m.hide! }
    redirect_to :back
  end


  # Returns a list of possible message recipients
  def recipient_list
    if current_user.role.student?
      respond_with current_client.users.not_students.all(:select => "id, username, firstname, lastname", :conditions => ["LOWER(username) LIKE :tag OR LOWER(firstname) LIKE :tag OR LOWER(lastname) LIKE :tag", { :tag => "%#{params[:tag].downcase}%" }], :order => "lastname ASC, firstname ASC")
    else
      respond_with current_client.users.all(:select => "id, username, firstname, lastname", :conditions => ["LOWER(username) LIKE :tag OR LOWER(firstname) LIKE :tag OR LOWER(lastname) LIKE :tag", { :tag => "%#{params[:tag].downcase}%" }], :order => "lastname ASC, firstname ASC")
    end
  end


  protected
    # The context of messaging is always the current user
    def begin_of_association_chain
      current_user
    end

    # Something odd happending 
    def build_resource
      @message ||= end_of_association_chain.new(params[:message])
    end
  
    # Make use of searchlogic, will_paginate and has_messages pre-defined associations depending on the current action
    def collection
      return @messages if defined?(@messages)

      # Setup some search defaults
      params[:search] ||= {}
      params[:search][:order] ||= :descend_by_created_at

      @search ||= end_of_association_chain.searchlogic(params[:search])
      @messages ||= @search.paginate(:include => { :recipients => :receiver }, :page => params[:page], :per_page => params[:per_page])
    end


  private
    def extract_message_recipients_from_request
      returning([]) do |recipients|
        # Extract the selected user from the request
        if recipient_ids = params[:message].delete(:recipient_ids)
          recipients << current_client.users.find(recipient_ids)
        end

        # Extract the selected class groups from the request
        if params[:class_group_ids].present?
          recipients << current_client.class_groups.find(params[:class_group_ids])
        end
      end
    end

  add_breadcrumb "Messaging", 'messages_path'
end

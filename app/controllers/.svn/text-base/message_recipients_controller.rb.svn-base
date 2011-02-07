#--
#  message_recipients_controller.rb
#  management
#  
#  Created by John Meredith on 2009-07-25.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class MessageRecipientsController < InheritedResources::Base
  respond_to :html
  actions :index

  # Make sure we mark the message as having been viewed
  def show
    resource.view
  end

  def reply
    resource_reply.body = params[:message][:body]
    if resource_reply.deliver
      set_flash_message!(:notice, "Reply sent")
      redirect_to resource_reply
    else
      set_flash_message!(:error)
      render :action => :show
    end
  end

  # PUT /messages/bulk_update
  def bulk_update
    if object_ids = params[:message_ids].keys
      current_user.received_messages.find_each(:conditions => { :id => object_ids }) { |m| m.hide! }
    end
    redirect_to :back
  end


  protected
    def resource_reply
      @message_reply ||= resource.reply
    end
    helper_method :resource_reply
  
    # Ensure the context is always the current_user's received messages
    def resource
      @message ||= current_user.received_messages.find(params[:id])
    end
  
    def collection
      return @messages if defined?(@messages)

      # Setup some search defaults
      params[:search] ||= {}
      params[:search][:order] ||= :descend_by_updated_at

      @search   ||= current_user.received_messages.searchlogic(params[:search])
      @messages ||= @search.paginate(:include => :message, :page => params[:page], :per_page => params[:per_page])
    end
end

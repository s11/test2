#--
#  dashboard_controller.rb
#  management
#  
#  Created by John Meredith on 2009-08-09.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class DashboardController < ApplicationController
  def index
    if current_menu.has_custom_dashboard?
      render :template => "dashboard/_custom" and return
    end

    # Messaging
    @unread_messages_count = current_user.received_messages.unread.count
    @unread_messages       = current_user.received_messages.unread.all(:order => "message_recipients.updated_at DESC", :limit => 5)


    # Tasksheet Submissions
    @tasksheet_submissions = case current_user.role
      when 'student'
        current_user.tasksheet_submissions.approved.all(:include => [ :tasksheet, :user, :class_group ], :order => "updated_at DESC", :limit => 10)
      when 'instructor'
        current_client.tasksheet_submissions.pending.all(:include => [ :tasksheet, :user, :class_group ], :conditions => { :class_group_id => current_user.class_group_ids }, :order => "updated_at DESC", :limit => 10)
      when 'supervisor'
        current_client.tasksheet_submissions.pending.all(:include => [ :tasksheet, :user, :class_group ], :conditions => { :class_group_id => current_client.class_group_ids }, :order => "updated_at DESC", :limit => 10)
    end


    # Recently viewed content
    content_items_ids     = current_user.activity_logs.all(:select => :category_item_id, :conditions => { 'categories.menu_version_id' => current_menu_version }, :joins => { :category_item => :category }, :order => "opened_at DESC", :group => "category_item_id", :limit => 10).map(&:category_item_id)
    @recent_content_items = current_menu_version.category_items.find(content_items_ids, :include => [:item, :category])


    # Random summary
    @random_category_item = current_menu_version.random_category_item
  end
end

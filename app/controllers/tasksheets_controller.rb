#--
#  tasksheets_controller.rb
#  management
#  
#  Created by John Meredith on 2009-06-28.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class TasksheetsController < InheritedResources::Base
  # InheritedResources
  respond_to :html
  actions :show


  helper_method :category, :category_item


  # Filters
  before_filter :build_breadcrumb_list
  after_filter  :add_activity_log, :only => :show


  protected
    def begin_of_association_chain
      category
    end

    # Add the category heiracrhy to the breadcrumb list
    def build_breadcrumb_list
      category = current_user.categories.first(:joins => :tasksheets, :conditions => ["tasksheets.id=?", resource.id] )
      category.self_and_ancestors.each { |category| add_breadcrumb category.name, category }
      add_breadcrumb resource.name, [category, resource]
    end

  private
    # Fetch the category
    def category
      return @category if defined?(@category)
      @category = Category.find(params[:category_id])
    end

    # Fetch the category item associated with the category and topic
    def category_item
      return @category_item if defined?(@category_item)
      @category_item = @category.category_items.tasksheets.first(:conditions => { :item_id => resource.id })
    end

    # Make sure we log the activity
    def add_activity_log
      current_user.activity_logs.create!(:login_at => current_user.current_login_at, :category_item => category_item, :opened_at => DateTime.now, :element => 'tasksheet')
    end
end

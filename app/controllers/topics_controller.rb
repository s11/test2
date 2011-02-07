#--
#  topics_controller.rb
#  management
#  
#  Created by John Meredith on 2009-07-07.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class TopicsController < InheritedResources::Base
  # InheritedResources
  respond_to :html
  actions :show, :video, :knowledge_check, :dvom, :workshop_procedure_guide, :handout_activity_sheet


  # Filters
  before_filter :build_breadcrumb_list
  after_filter  :add_activity_log, :only => [:show, :video, :knowledge_check, :dvom, :workshop_procedure_guide, :handout_activity_sheet]


  # Helpers
  helper_method :category, :category_item, :exclusive_dvom_topic?


  # Need to override the layout for info
  def info
    render :action => "info", :layout => "popup"
  end

  protected
    def begin_of_association_chain
      category
    end
  
    # Add the category heiracrhy to the breadcrumb list
    def build_breadcrumb_list
      category = current_user.categories.first(:joins => :topics, :conditions => ["topics.id=?", resource.id] )
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
      @category_item = @category.category_items.topics.first(:conditions => { :item_id => resource.id })
    end

    # Returns true of the topic is exclusively a DVOM
    def exclusive_dvom_topic?
      category_item.has_dvom? && (resource.page_filename.gsub(/_2/, '') == category_item.dvom_filename)
    end

    # Make sure we log the activity
    def add_activity_log
      element_type = case params[:action]
        when 'show'
          'html'
        when 'workshop_procedure_guide'
          'workshop activity'
        when 'handout_activity_sheet'
          'handout activity'
        else
          params[:action].gsub(/_/, ' ')
      end
      
      current_user.activity_logs.create!(:login_at => current_user.current_login_at, :category_item => category_item, :opened_at => DateTime.now, :element => element_type)
    end
end

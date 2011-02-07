#--
#  categories_controller.rb
#  management
#  
#  Created by John Meredith on 2009-06-29.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class CategoriesController < InheritedResources::Base
  actions :show, :chain_select


  before_filter :build_breadcrumb_list, :except => :chain_select



  protected
    # We want to limit the categories displayed / searched to the current users menu version
    def begin_of_association_chain
      current_menu_version
    end
  
    # We want to take advantage of searchlogic, so override the collection method.
    def collection
      @search ||= end_of_association_chain.searchlogic(params[:search])
      @users  ||= @search.all
    end
    
    # Add the category heiracrhy to the breadcrumb list
    def build_breadcrumb_list
      resource.self_and_ancestors.each { |category| add_breadcrumb category.name, category }
    end
end

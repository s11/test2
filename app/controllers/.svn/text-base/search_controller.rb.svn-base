# 
#  search_controller.rb
#  management
#  
#  Created by John Meredith on 2009-07-09.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
# 
class SearchController < ApplicationController
  # do not require the search for the test action, it will do it's own preset search.
  before_filter :perform_search, :except => :test
  # do not require login for the test search page, this will be used by alertra so it can detect when the sphinx index is messed up.
  skip_before_filter :require_user, :set_moodle_database, :require_current_terms_and_conditions_acceptance, :add_home_breadcrumb, :only => :test

  # GET /search/popup.html
  def popup
    render :layout => 'popup'
  end
  
  # Action to test the search functionality
  def test
    # do a test search for clutches...
    @search = CategoryItem.search('clutch',
                                  :match_mode => :extended,
                                  :include    => [ :category, :item ],
                                  :with       => { :category_menu_version_id => 41 })
    render :layout => 'popup'
  end

  private 
    def perform_search
      @search = CategoryItem.search(
        params[:query],
        :match_mode => :extended,
        :include    => [ :category, :item ],
        :with       => { :category_menu_version_id => current_menu_version.id },
        :page       => params[:page],
        :per_page   => 10
      ) unless params[:query].blank?
    end
end

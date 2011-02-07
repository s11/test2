# 
#  routes.rb
#  online
#  
#  Created by John Meredith on 2008-02-16.
#  Copyright 2008 CDX Global. All rights reserved.
# 
ActionController::Routing::Routes.draw do |map|
  # Map content
  map.resources :categories, :only => :show, :collection => { :chain_select => :post }, :shallow => false do |category|
    category.resources :tasksheets, :only => :show
    category.resources :topics, :only => :show, :member => {
      :video                    => :get,
      :knowledge_check          => :get,
      :dvom                     => :get,
      :workshop_procedure_guide => :get,
      :handout_activity_sheet   => :get,
      :info                     => :get
    }
  end


  # Print support
  map.resource :print_support, :controller => 'print_support', :only => :show, :member => { :content => :get }
  map.print_support_content 'print_support/content/*filename_details', :controller => 'print_support', :action => 'content'


  # More static content. Mainly Info & Help.
  map.with_options :controller => "information", :path_prefix => "/info" do |info|
    info.info_about         '/about',             :action => "about"
    info.info_contacts      '/contacts',          :action => "contacts"
    info.info_help          '/help',              :action => "help"
    info.info_ksdp          '/know_see_do_prove', :action => "know_see_do_prove"
    info.info_navigation    '/navigation',        :action => "navigation"
    info.info_pdf           '/pdf/:filename',     :action => "pdf"
    info.info_walkthrough   '/walkthrough/:name', :action => "walkthrough"
  end


  # Content search
  map.search        '/search',                :controller => "search", :action => "index"
  map.moodle_search '/search/popup/:query',   :controller => 'search', :action => 'popup', :query => nil
  map.test_search   '/search/test',           :controller => 'search', :action => 'test', :query => nil


  # Messaging
  map.inbox           '/messages/inbox',  :controller => :message_recipients, :action => :index
  map.draft_messages  '/messages/drafts', :controller => :messages,           :action => :index, :by_state => "unsent"
  map.sent_messages   '/messages/sent',   :controller => :messages,           :action => :index, :by_state => "sent"
  map.resources :message_recipients, :only => [:index, :show], :collection => { :bulk_update => :put }, :member => { :reply => :post }
  map.resources :messages, :collection => { :bulk_destroy => :delete, :recipient_list => :get }, :member => { :reply => :post }


  # Tasksheet management
  map.resources :tasksheet_submissions, :collection => {
    :pending     => :get,
    :approved    => :get,
    :rejected    => :get,
    :bulk_new    => :get,
    :bulk_create => :post,
    :bulk_update => :put,
  }

  
  # Reporting is now a resource that can CRUD'd
  map.resources :reports
  map.resources :assessment_views, :only => :none, :collection => { :chain_select => :post }
  # map.resources :report, :only => [:diagnostics], :collection => { :diagnostics => :get }
  # map.reports 'report/:action', :controller => 'report'
  # map.reports 'report/:action.:format', :controller => 'report'

  
  # Diagnostics
  map.diagnostics '/diagnostics', :controller => 'diagnostics', :action => 'index'
  map.namespace :diagnostics do |diag|
    diag.exam_attempt_result  '/exam/:exam_id/attempt/:attempt_id/result',    :controller => 'attempts',    :action => 'result'
    diag.exam_hint            '/exam/:exam_id/hint/:classification',          :controller => 'attempts',    :action => 'hint'
    diag.exam_start           '/exam/:system_name/:scenario_num',             :controller => 'exams',       :action => 'start'
    
    diag.solution             '/info/solution/:scenario_id',                  :controller => 'information', :action => 'solution'
    diag.information          '/info/:action/:choice_quality',                :controller => 'information', :choice_quality => nil
    
    diag.resources :scenarios, :only => :none, :collection => { :chain_select => :post }
    diag.resources :exams, :only => :none do |exam|
      exam.resources :attempts, :only => [:create, :verify, :identify, :rectify], :collection => {
        :verify   => :get,
        :identify => :get,
        :rectify  => :get,
      }
    end
  end


  # Client / Users
  map.resources :users, :collection => { :students => :get, :instructors => :get, :bulk_update => :put }
  map.resources :csv_files, :as => :student_import, :only => [:new, :create]
  map.sample_csv_download '/student_import/download_sample', :controller => "csv_files", :action => 'sample_csv_download'

  map.with_options :controller => "users", :role => "instructor" do |instructor|
    instructor.instructors    '/instructors.:format', :action => "index"
    instructor.new_instructor '/instructors/new',     :action => "new"
  end

  map.with_options :controller => "users", :role => "student" do |student|
    student.students    '/students.:format',  :action => "index"
    student.new_student '/students/new',      :action => "new"
  end
  
  # CDX access code card registration
  map.resource :access_pack, :only => [:new, :create], :member => { :create => [:get, :post] }
  map.registration '/registration', :controller => "access_packs", :action => 'new'

  # Account handles the instance, profile the current user's information
  map.resource  :account, :only => [:show, :edit, :update]
  map.resources :class_groups, :collection => { :bulk_update => :put }, :member => { :copy => :get }
  map.resource  :profile, :only => [:show, :edit, :update], :member => { :update_video_size => :put }


  # Authentication
  map.resource  :user_session, :only => [:new, :create, :destroy], :member => { :create => [:get, :post] }
  map.login     '/login',   :controller => "user_sessions",  :action => 'new'
  map.logout    '/logout',  :controller => "user_sessions",  :action => 'destroy'

  
  # Terms and conditions
  map.resources :terms_and_conditions_acceptances, :only => [ :new, :create ], :as => :terms_and_conditions


  # External API
  map.namespace :api do |api|
    api.with_options :collection => { :count => :get } do |count|
      count.resources :menus, :only => [:index, :show] do |menu|
        menu.resources :versions, :controller => :menu_versions, :collection => { :count => :get }
      end

      count.resources :districts do |district|
        district.resources :clients, :collection => { :count => :get }
      end

      count.resources :clients do |client|
        client.resources :access_packs, :only => :index, :collection => { :assign_range => :put, :count => :get }
        client.resources :districts,    :collection => { :count => :get }
        client.resources :users,        :collection => { :count => :get }
      end
    end
  end

  
  map.root :controller => "dashboard", :action => "index"
end

#--
#  reports_helper.rb
#  management
#  
#  Created by John Meredith on 2009-08-07.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
module ReportsHelper
  extend ActiveSupport::Memoizable


  def order_by_link(name)
    link_text = name.gsub(/\//, ' / ')

    if params[:sort_by].eql?(name)
      direction = params[:sort_as].eql?('ascending') ? :descending : :ascending

      if direction == :ascending
        link_text = "&#9660;&nbsp;" + link_text
      else
        link_text = "&#9650;&nbsp;" + link_text
      end
    end

    link_to link_text, url_for(params.except(:page).merge(:sort_by => name, :sort_as => direction))
  end


  # Generate a select chain of the given category and it's ancestors
  def assessment_view_select_chain(name, *args)
    options = {
      :menu_version_id => nil,
      :hierarchy_id    => nil,
      :type            => nil
    }.merge(args.extract_options!)

    menu_version   = MenuVersion.find(options[:menu_version_id])
    hierarchy_root = menu_version.send(options[:type])
    
    if options[:hierarchy_id].present? && menu_version.assessment_views.exists?(options[:hierarchy_id])
      assessment_view = menu_version.assessment_views.find(options[:hierarchy_id])
      ancestors       = assessment_view.self_and_ancestors unless assessment_view.level == 1
    end

    dropdowns = ActiveSupport::OrderedHash.new
    if ancestors.blank?
      dropdowns[0] = chained_select_tag(:name => name, :categories => hierarchy_root.children, :selected => options[:hierarchy_id], :level => 0, :url => chain_select_assessment_views_path)
    else
      ancestors.each do |ancestor|
        dropdowns[ancestor.level] = chained_select_tag(:name => name, :categories => ancestor.self_and_siblings, :selected => ancestor.id, :level => ancestor.level, :all_value => (ancestor.child? ? ancestor.id : nil), :parent => ancestor.parent, :url => chain_select_assessment_views_path)
      end
    end

    dropdowns[assessment_view.level + 1] = chained_select_tag(:name => name, :categories => assessment_view.children, :level => (assessment_view.level + 1), :all_value => assessment_view.id, :parent => assessment_view.parent, :url => chain_select_assessment_views_path) if assessment_view

    nested_chain_builder(dropdowns.to_a)
  end


  # Generate a select chain of the given category and it's ancestors
  def category_select_chain(name, *args)
    options = {
      :menu_version_id => nil,
      :category_id     => nil
    }.merge(args.extract_options!)
  
    menu_version = MenuVersion.find(options[:menu_version_id])
    
    if options[:category_id] && Category.exists?(options[:category_id])
      category  = menu_version.categories.find(options[:category_id])
      ancestors = category.self_and_ancestors unless category.root?
    end
  
    dropdowns = ActiveSupport::OrderedHash.new
    if ancestors.blank?
      dropdowns[0] = chained_select_tag(:name => name, :categories => menu_version.root_categories, :selected => options[:category_id], :level => 0)
    else
      ancestors.each do |ancestor|
        dropdowns[ancestor.level] = chained_select_tag(:name => name, :categories => ancestor.self_and_siblings, :selected => ancestor.id, :level => ancestor.level, :all_value => (ancestor.child? ? ancestor.id : nil), :parent => ancestor.parent)
      end
    end
  
    dropdowns[category.level + 1] = chained_select_tag(:name => name, :categories => category.children, :level => (category.level + 1), :all_value => category.id, :parent => category.parent) if category
  
    nested_chain_builder(dropdowns.to_a)
  end


  def diagnostics_select_chain(system_name, scenario_name, *args)
    options = {
      :system_id => nil,
      :scenario  => nil
    }.merge(args.extract_options!)
    
    # The systems select box
    output = select_tag(system_name, "<option value=''>All Systems</option>" + options_from_collection_for_select(Diagnostics::System.all, 'id', 'name', options[:system_id].try(:to_i)), :id => :system_id)
    output << observe_field(:system_id, :url => chain_select_diagnostics_scenarios_path, :with => "'placeholder=scenario_id&system_id=' + value")

    # Given a selected system that exists, display the associated scenarios
    if Diagnostics::System.exists?( options[:system_id] )
      output << content_tag(:span, :id => :scenario_id) do
        scenarios        = Diagnostics::Scenario.all(:conditions => { :system_id => options[:system_id], :is_practice => false })
        scenario_options = options_from_collection_for_select(scenarios, :id, :name, options[:scenario].try(:to_i))
        select_tag(scenario_name, "<option value=''>All Scenarios</option>" + scenario_options, :id => :scenario_id)
      end
    else
      output << "<span id='scenario_id'></span>"
    end
  end

  private
    def selector_id(level)
      "chained_selector_#{level}"
    end
    memoize :selector_id

    # Suffixes "_placholder" onto the given identifier
    def placeholder(level)
      "#{ selector_id(level) }_placeholder"
    end
    memoize :placeholder

    # Creates a select tag given the various options
    def chained_select_tag(*args)
      options = {
        :all_value  => nil,
        :categories => nil,
        :level      => 0,
        :name       => nil,
        :parent     => nil,
        :selected   => nil,
        :url        => chain_select_categories_path
      }.merge(args.extract_options!)

      result = select_tag(options[:name], "<option id='#{selector_id(options[:level])}_first_option' value='#{options[:all_value]}'>All Categories</option>" + options_from_collection_for_select(options[:categories], :id, :name, options[:selected]), :id => selector_id(options[:level]))
      result << observe_field(selector_id(options[:level]), :url => options[:url], :with => "'name=#{options[:name]}&selector_id=#{selector_id(options[:level])}&placeholder=#{placeholder(options[:level])}&selected_parent_value=#{options[:parent].try(:id)}&id=' + value")
    end

    # Creates a nested chain of select statements
    def nested_chain_builder(dropdowns)
      "#{dropdowns[0].second} <span id='#{placeholder(dropdowns[0].first)}'>#{nested_chain_builder(dropdowns[1..-1])}</span>" unless dropdowns.blank?
    end
end

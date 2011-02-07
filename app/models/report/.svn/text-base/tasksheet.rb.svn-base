#--
#  tasksheet.rb
#  management
#  
#  Created by John Meredith on 2009-08-05.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class Report::Tasksheet < Report
  INDIVIDUAL_COLUMNS = ['Taskshet Number', 'Description', 'NATEF|Priority', 'NATEF|Reference', 'Completed On', 'Grade', 'Average']


  # Preferences --------------------------------------------------------------------------------------------------------------------
  preference :averages_row,           :default => true
  preference :individual_report,      :default => true
  preference :menu_version_selection, :default => false



  def report_data
    return @report_data if defined?(@report_data)

    @report_data = []

    categories.each do |category|

      # We need to split the report up into NATEF priorities for those menus that allow selection of NATEF task areas (predominantly ASE)
      if menu_version.has_natef_selection?
        %w{ P1 P2 P3 }.each do |priority|
          tasksheet_ids = NatefTaskArea.all(:select => "tasksheet_id", :conditions => { :version => category.version, :description => category.description, :natef_priority => priority }).map(&:tasksheet_id)

          @report_data << tasksheet_column_data("#{category.description}|#{priority}", tasksheet_ids, priority).each do |r|
            r['user_id'] = r['user_id'].to_i
          end
        end
      else
        tasksheet_ids = menu_version.category_items.tasksheets.all(:select => "item_id AS id", :conditions => { :category_id => category.self_and_descendant_ids }, :group => "item_id").map(&:id)

        @report_data << tasksheet_column_data(category.name, tasksheet_ids).each do |r|
          r['user_id'] = r['user_id'].to_i
        end
      end
    end

    @report_data.flatten!
  end


  def individual_ruport_table(*args)
    options = returning(args.extract_options!) do |o|
      o[:sort_by] ||= nil
      o[:sort_as] ||= nil
    end

    # Build our filtered search
    search = owner.tasksheet_submissions.approved.between_dates(date_range_start, date_range_end).grade_greater_than(preferred_minimum_grade).searchlogic

    # Make sure we're only reporting on the client's selected NATEF areas
    if menu_version.has_natef_selection?
      search.by_natef_version(categories.first.version)
      search.by_natef_description(categories.map(&:description))
    end

    search.all(
      :include => :tasksheet,
      :group   => "tasksheet_submissions.tasksheet_id, tasksheet_submissions.completed_on",
      :order   => "tasksheet_submissions.tasksheet_id ASC, tasksheet_submissions.completed_on DESC"
    ).group_by(&:tasksheet)
  end


  # Return a formatted version of the given data. Used to override the cell display
  def format_cell(data, supplemental_data = nil)
    return if data.blank?

    # Split back out into priority and percentage for NATEF enabled menus
    if menu_version.has_natef_selection?
      priority, value = data.split('|')
      bar_graph(value, priority)
    else
      "<div class='centre'>%0.1f%%</div>" % data
    end
  end

  def format_footer_cell(name)
    column_data = @paginated_ruport_table.column(name).compact

    return "<img src='/images/blank.gif' width='75px' height='1px' />" if column_data.blank?

    if menu_version.has_natef_selection?
      priority      = column_data.first.split('|').first
      column_values = column_data.map { |r| r.split('|').second.to_f }
      total         = column_values.sum
      average       = total / column_values.size.to_f

      bar_graph(average, priority)
    else
      "<div class='centre'>%0.1f%%</div>" % (column_data.map { |r| r.to_f }.sum / column_data.size)
    end
  end
  
  # Render the report as the format given ie. PDF or CSV
  def render(format, user, *args)
    TasksheetReport.render(format, :report => self, :user => user)
  end
  
  protected
    def data_column_names
      return @data_column_names if defined?(@data_column_names)

      if menu_version.has_natef_selection?
        @data_column_names = []
        categories.map(&:name).each do |name|
          %w{ P1 P2 P3 }.each { |priority| @data_column_names << "#{name}|#{priority}" }
        end
      else
        @data_column_names = categories.map(&:name)
      end
      
      @data_column_names
    end


  private
    # We want to be able to set the hierarchy_id and autoload the category if necessary
    def hierarchy_with_auto_populate
      return hierarchy_without_auto_populate if hierarchy_without_auto_populate.present?
      owner.natef_certified_areas.find(hierarchy_id) if hierarchy_id.present?
    end
    alias_method_chain :hierarchy, :auto_populate

    # Return the categories
    def categories
      return @categories if defined?(@categories)

      if menu_version.has_natef_selection?
        if hierarchy_id.blank?
          @categories = owner.natef_certified_areas.all(:order => "description")
        else
          @categories = [hierarchy]
        end
      else
        if hierarchy_id.blank?
          @categories = (menu_version || owner.menu_version).categories.roots 
        else
          @categories = hierarchy.try(:children) || [hierarchy]
        end
      end

      @categories
    end

    def tasksheet_column_data(column_name, tasksheet_ids, priority = nil)
      # Perform the query
      query_result = owner.tasksheet_submissions.approved.by_user(all_user_ids).by_tasksheet_id(tasksheet_ids).between_dates(date_range_start, date_range_end).grade_greater_than(preferred_minimum_grade).all(:select => "user_id, COUNT(DISTINCT(tasksheet_id)) AS value, '#{column_name}' AS column_name", :group => "user_id", :order => "grade DESC" )
      result = query_result.map(&:attributes)

      result.each do |r|
        if menu_version.has_natef_selection?
          r['value'] = "#{priority}|%f" % (r['value'].to_f * 100 / tasksheet_ids.size)
        else
          r['value'] = r['value'].to_f * 100 / tasksheet_ids.size
        end
      end

      if include_all_users?
        query_result_user_ids = query_result.map(&:user_id).map(&:to_i)
        all_user_ids.map do |user_id|
          unless query_result_user_ids.include?(user_id)
            result << returning({}) do |h|
              h['user_id']     = user_id
              h['value']       = nil
              h['column_name'] = nil
              h['priority']    = priority if menu_version.has_natef_selection?
            end
          end
        end
      end
      
      return result
    end
    
    # Output the HTML required to display a nice-ish bar graph for each cell
    #
    # FIXME: Need to separate this out into a view helper
    def bar_graph(percentage, priority)
      case priority.to_sym
        when :P1
          required_percentage = 95
        when :P2
          required_percentage = 85
        when :P3
          required_percentage = 50
      end

      output = "<div class='tasksheet'>"

      # Change the colour of the bar depending on whether the criteria has been met
      output << "<div class='graph'>"
      if percentage.to_i >= required_percentage
        output << "<img src='/images/lime_pixel.gif', height='20px', width='%0.1f%%'/>" % percentage
      else
        output << "<img src='/images/tangerine_pixel.gif', style='min-width: 1px', height='20px', width='%0.1f%%'/>" % percentage

        if (required_percentage - percentage.to_i) > 0
          output << "<img src='/images/banana_pixel.gif', height='20px', width='%0.1f%%'/>" % (required_percentage - percentage.to_f)
        end
      end
      output << "</div>"

      output << "<div class='label'>%0.1f%%</div>" % percentage
      output << "</div>"
    end
end

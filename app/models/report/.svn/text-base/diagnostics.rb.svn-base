# == Schema Information
# Schema version: 20091007002944
#
# Table name: reports
#
#  id                  :integer(4)      not null, primary key
#  type                :string(255)
#  name                :string(255)     not null
#  owner_id            :integer(4)      not null
#  owner_type          :string(255)     not null
#  menu_id             :integer(4)
#  menu_version_id     :integer(4)
#  class_group_id      :integer(4)
#  hierarchy_id        :integer(4)
#  hierarchy_type      :string(255)
#  date_range_start    :datetime
#  date_range_end      :datetime
#  include_all_users   :boolean(1)      default(TRUE), not null
#  include_all_columns :boolean(1)      default(TRUE), not null
#  created_at          :datetime
#  updated_at          :datetime
#  deleted_at          :datetime
#  lock_version        :integer(4)      default(1), not null
#  role                :string(255)
#

#--
#  diagnostics.rb
#  management
#  
#  Created by John Meredith on 2009-08-05.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class Report::Diagnostics < Report
  # Preferences --------------------------------------------------------------------------------------------------------------------
  preference :menu_version_selection, :boolean, :default => false
  preference :scenario,               :integer, :default => nil


  def report_data
    return @report_data if defined?(@report_data)

    logger.debug { "Owner: #{owner.diagnostics_exams.inspect}" }
    #logger.debug { "paulm_owner: #{owner.inspect}" }
    # owner is the client

    @report_data = []
    columns.each do |column|
      search = owner.diagnostics_exams.assessment.between_dates(date_range_start, date_range_end).searchlogic

      # Make sure we limit by the set of users
      # search.user_id = all_user_ids

      # We distinguish between systems and scenarios
      if column.is_a?(::Diagnostics::Scenario)
        search.by_scenario(column)
      else
        search.by_system(column)
      end

      logger.debug { "Search: #{search.inspect}" }

      # Fetch out result
      query_result = search.all(:select => "'#{column.name}' AS column_name, user_id, #{sql_aggregation_method}(ALL final_mark) AS value, COUNT(*) AS attempts, COUNT(ALL final_mark) AS completed", :group => "user_id")
      result = query_result.map(&:attributes)

      # Concatenate the result attributes which will later be extracted
      result.each do |r|
        r['user_id'] = r['user_id'].to_i
        r['value']   = "#{r['value']}|#{r['completed']}|#{r['attempts']}"
      end

      # Add in the extra users if requested
      if include_all_users?
        query_result_user_ids = query_result.map(&:user_id).map(&:to_i)
        all_user_ids.map do |user_id|
          unless query_result_user_ids.include?(user_id)
            result << {
              'user_id'     => user_id,
              'column_name' => column.name,
              'value'       => nil
            }
          end
        end
      end

      @report_data << result
    end
    
    @report_data.flatten!
  end

  # Return a formatted version of the given data. Used to override the cell display
  def format_cell(data, supplemental_data = nil)
    return nil if data.blank?

    bits = data.split('|')
    if bits[0].blank?
      "<div class='centre'>(%d of %d completed)</div>" % bits[1..-1]
    else
      "<div class='centre'>%0.1f<br/>(%d of %d completed)</div>" % bits
    end
  end

  # Render the report as the format given ie. PDF or CSV
  def render(format, user, *args)
    DiagnosticsReport.render(format, :report => self, :user => user)
  end

  protected
    def data_column_names
      @data_column_names ||= columns.map(&:name)
    end


  private
    # We want to be able to set the hierarchy_id and autoload the category if necessary
    def hierarchy_with_auto_populate
      return hierarchy_without_auto_populate if hierarchy_without_auto_populate.present?

      ::Diagnostics::System.find(hierarchy_id) if hierarchy_id.present?
    end
    alias_method_chain :hierarchy, :auto_populate


    # NOTE: Need to extend to scenarios
    def columns
      return @columns if defined?(@columns)
      
      if hierarchy_id.present?
        if preferred_scenario.blank?
          @columns = hierarchy.scenarios.all
        else
          @columns = [ hierarchy.scenarios.first(preferred_scenario) ]
        end
      else
        @columns = ::Diagnostics::System.all
      end
      
      @columns.sort! { |a, b| a.name.gsub(/\D*/, '').to_i <=> b.name.gsub(/\D*/, '').to_i }
    end
end

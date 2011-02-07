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
#  activity.rb
#  management
#  
#  Created by John Meredith on 2009-08-05.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class Report::Activity < Report
  # Preferences --------------------------------------------------------------------------------------------------------------------
  preference :totals_row, :default => true


  # FIXME:  Unfortunately we still have to read in all the data before sorting and filtering. I'm assuming some serious SQLfu would
  #         be required to solve this issue and come up with a solution that the DB can handle on it's own. Suggestions more than
  #         welcome.
  # 
  #         On further deliberation, we may be able to dynamically create result (ie. pivotted) directly with one query... I'll
  #         think more about this.
  def report_data
    return @report_data if defined?(@report_data)
    
    @report_data = []
    categories.each do |cat|
      # Grab all the category ids
      category_and_descendant_ids = cat.self_and_descendants.all(:select => "id").map(&:id)

      # Fetch our result
      query_result = owner.activity_logs.by_user(all_user_ids).between_dates(date_range_start, date_range_end).all(
        :select     => "'#{cat.name}' AS column_name, user_id, SUM(TIMESTAMPDIFF(SECOND, opened_at, closed_at)) AS value",
        :joins      => :category_item, 
        :conditions => { :categories_items => { :category_id => category_and_descendant_ids }},
        :group      => "user_id"
      )
      result = query_result.map(&:attributes)

      if include_all_users?
        query_result_user_ids = query_result.map(&:user_id)
        all_user_ids.map do |user_id|
          unless query_result_user_ids.include?(user_id)
            result << {
              'user_id'     => user_id,
              'value'       => nil,
              'column_name' => cat.name
            }
          end
        end
      end

      @report_data << result.each do |r|
        r['user_id'] = r['user_id'].to_i
        r['value']   = r['value'].try(:to_i)
      end
    end

    @report_data.flatten!
  end

  # Return a formatted version of the given data. Used to override the cell display
  def format_cell(data, supplemental_data = nil)
    return if data.blank?

    "<div class='centre'>%s</div>" % seconds_to_duration(data)
  end

  # Render the report as the format given ie. PDF or CSV
  def render(format, user, *args)
    ActivityReport.render(format, :report => self, :user => user)
  end


  protected
    def data_column_names
      categories.map(&:name)
    end

  private
    # We want to be able to set the hierarchy_id and autoload the category if necessary
    def hierarchy_with_auto_populate
      menu_version.categories.find(hierarchy_id) if hierarchy_id.present?
    end
    alias_method_chain :hierarchy, :auto_populate

    # Return the categories
    def categories
      return (menu_version || owner.menu_version).categories.roots if hierarchy_id.blank?
      hierarchy.try(:children) || [ hierarchy ]
    end

    # Convert seconds to 
    def seconds_to_duration(seconds)
      return nil if seconds.blank?
      "%0.2d:%0.2d:%0.2d" % [seconds.to_i / 3600, (seconds.to_i % 3600) / 60, (seconds.to_i % 3600) % 60]
    end
end

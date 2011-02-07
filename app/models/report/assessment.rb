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
#  assessment.rb
#  management
#  
#  Created by John Meredith on 2009-08-05.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class Report::Assessment < Report
  def report_data
    return @report_data if defined?(@report_data)

    @report_data = []
    categories.each do |category|
      query_result = Moodle::QuizAttempt.between_dates(date_range_start, date_range_end).by_quiz_id(category.quiz_ids).by_user_id(all_user_ids).all(
        :select => "'#{category.name}' AS column_name, username AS user_id, #{sql_aggregation_method}(cdx_quiz.grade * cdx_quiz_attempts.sumgrades / cdx_quiz.sumgrades) AS value, COUNT(cdx_quiz_attempts.attempt) AS number_of_attempts",
        :group  => "userid"
      )
      result = query_result.map(&:attributes)

      if include_all_users?
        query_result_user_ids = query_result.map {|r| r['user_id'] }
        all_user_ids.each do |user_id|
          unless query_result_user_ids.include?(user_id)
            result << {
              'user_id'            => user_id.to_i,
              'value'              => nil,
              'number_of_attempts' => nil,
              'column_name'        => category.name
            }
          end
        end
      end

      # NOTE: Assessment results can never have a value less than 0, so assign the value to -1 on nil. Will be stripped in the method
      #       format_cell below
      @report_data << result.each do |r|
        r['user_id'] = r['user_id'].to_i
        
        if r['value'].blank?
          r['value'] = -1
        else
          r['value'] = "#{ '%0.1f' % r['value'] }<br/>(#{ r['number_of_attempts'] } attempted)"
        end
      end
    end
    
    @report_data.flatten!
  end

  # Return a formatted version of the given data. Used to override the cell display
  def format_cell(data, supplemental_data = nil)
    return if data == -1

    "<div class='centre'>#{data}</div>"
  end

  # Render the report as the format given ie. PDF or CSV
  def render(format, user, *args)
    AssessmentReport.render(format, :report => self, :user => user)
  end


  protected
    def data_column_names
      categories.map(&:name)
    end


  private
    # We want to be able to set the hierarchy_id and autoload the category if necessary
    def hierarchy_with_auto_populate
      return hierarchy_without_auto_populate if hierarchy_without_auto_populate.present?
      menu_version.assessment_views.find(hierarchy_id) if hierarchy_id.present?
    end
    alias_method_chain :hierarchy, :auto_populate

    # Return the categories
    def categories
      return menu_version.send(preferred_assessment_type).children if hierarchy_id.blank?
      
      if hierarchy.try(:children).present?
        hierarchy.children
      else
        [ hierarchy ]
      end
    end
end


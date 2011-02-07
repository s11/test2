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
#  report.rb
#  management
#  
#  Created by John Meredith on 2009-08-05.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class Report < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  # Contants -----------------------------------------------------------------------------------------------------------------------
  STANDARD_COLUMNS = ['Student ID', 'Last Name', 'First Name']
  

  # Associations -------------------------------------------------------------------------------------------------------------------
  belongs_to :owner, :polymorphic => true
  belongs_to :menu
  belongs_to :menu_version
  belongs_to :class_group
  belongs_to :hierarchy, :polymorphic => true



  # Validations --------------------------------------------------------------------------------------------------------------------
  validates_presence_of :owner_id, :name
  validates_associated  :owner, :menu, :menu_version, :class_group



  # Scopes -------------------------------------------------------------------------------------------------------------------------
  default_scope :conditions => "#{table_name}.deleted_at IS NULL OR #{table_name}.deleted_at > UTC_TIMESTAMP()"
  named_scope :by_type, lambda { |type| { :conditions => ["type=?", "Report::#{type.to_s.capitalize}"] }}

  # Convenient scopes
  named_scope :activity,    :conditions => { :type => "Report::Activity"    }
  named_scope :assessment,  :conditions => { :type => "Report::Assessment"  }
  named_scope :diagnostics, :conditions => { :type => "Report::Diagnostics" }
  named_scope :tasksheet,   :conditions => { :type => "Report::Tasksheet"   }



  # Preferences --------------------------------------------------------------------------------------------------------------------
  preference :aggregation_method,     :string,  :default => "maximum"
  preference :assessment_type,        :string
  preference :averages_row,           :boolean, :default => false
  preference :individual_report,      :boolean, :default => false
  preference :menu_version_selection, :boolean, :default => true
  preference :minimum_grade,          :integer, :default => 0
  preference :totals_row,             :boolean, :default => false



  # Set a reasonable default for the start date
  def date_range_start
    read_attribute(:date_range_start) || "2007-01-01".to_time
  end

  # Set a reasonable default for the end date
  def date_range_end
    read_attribute(:date_range_end) || Time.now.in_time_zone.end_of_day
  end

  # Returns a Ruport table which is useful for exporting to PDF, CSV and Excel
  def ruport_table(*args)
    options = returning(args.extract_options!) do |o|
      o[:sort_by]         ||= ["Last Name", "First Name"]
      o[:sort_as]         ||= :ascending
    end

    # Build the final table
    table = Table(["column_name", "user_id", "value"]) do |feeder|
      report_data.each { |row| feeder << row } if report_data.present?
    end
    @ruport_table = table.pivot('column_name', :group_by => "user_id", :values => 'value')

    # Add the user columns
    grouped_users = all_users.index_by(&:id)
    @ruport_table.add_column('Student ID') { |r| grouped_users[r.user_id].andand.student_id  }
    @ruport_table.add_column('Last Name')  { |r| grouped_users[r.user_id].andand.lastname    }
    @ruport_table.add_column('First Name') { |r| grouped_users[r.user_id].andand.firstname   }
    
    # Get the columns in the right order
    @ruport_table.reorder(["user_id", "First Name", "Last Name", "Student ID"] + data_column_names)
    
    # ..and sort
    @ruport_table.sort_rows_by!(options[:sort_by], :order => options[:sort_as].try(:to_sym))
    @ruport_table
  end
  memoize :ruport_table
  
  def individual_ruport_table(*args)
  end
  memoize :individual_ruport_table

  # Wrap the report data in a paginated collection
  #
  # Example:
  # 
  #   Report.paginated_ruport_table(1, :per_page => 20)
  def paginated_ruport_table(page, *args)
    options = returning(args.extract_options!) do |o|
      o[:per_page]        ||= 20
      o[:sort_by]         ||= nil
      o[:sort_as]         ||= nil
    end
    
    # Clone the report
    # 
    # NOTE: Could be an expensive operation if the table is large
    @paginated_ruport_table = ruport_table(:sort_by => options[:sort_by], :sort_as => options[:sort_as]).dup

    # ... and reorder the columns
    if include_all_columns?
      @paginated_ruport_table.reorder(["user_id", "First Name", "Last Name", "Student ID"] + data_column_names)
    else
      result_column_names = data_column_names.select { |n| @paginated_ruport_table.column_names.include?(n) }
      @paginated_ruport_table.reorder(["user_id", "First Name", "Last Name", "Student ID"] + result_column_names)
    end

    # Wrap the report data in a paginated collection
    @paginated_ruport_table.data = WillPaginate::Collection.create(page, options[:per_page], @paginated_ruport_table.size) do |pager|
      pager.replace @paginated_ruport_table.data[pager.offset, pager.per_page].to_a
    end

    @paginated_ruport_table
  end
  memoize :paginated_ruport_table


  # Return a formatted version of the given data. Used to override the cell display
  def format_cell(data, supplemental_data = nil)
    data.to_s
  end


  # Return a formatted version of the given data. Used to override the cell display
  def sigma_format_cell(data, supplemental_data = nil)
    data.to_s
  end

  # Render the report as the format given ie. PDF or CSV
  def render(format, user, *args)
  end

  protected
    # Either the client's user or the user
    def all_users
      return @all_users if defined?(@all_users)

      if owner.respond_to?(:users)
        if class_group.present?
          if role.present?
            @all_users = class_group.users.by_role(role)
          else
            @all_users = class_group.users 
          end
        else
          if role.present?
            @all_users = owner.users.by_role(role)
          else
            @all_users = owner.users
          end
        end
      else
        @all_users = [ owner ]
      end
      
      @all_users
    end

    # All user ids
    def all_user_ids
      @all_user_ids ||= all_users.map(&:id)
    end
    
    def sql_aggregation_method
      case preferred_aggregation_method
        when 'average'
          return 'AVG'
        when 'minimum'
          return 'MIN'
        else
          return 'MAX'
      end
    end
    
    def split_header_row
    end
end

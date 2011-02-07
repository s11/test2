# 
#  assessment.rb
#  report_rework
#  
#  Created by John Meredith on 2008-04-09.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class AssessmentReport < Ruport::Controller
  
  COLUMNS           = %w(username category_name grade sumgrades attempts)
  MAX_DATA_COLUMNS  = 7
  PAGE_WIDTH        = 800
  
  stage :assessment
  
  def setup
    self.data = options.report.ruport_table
  end
  
  module Helpers
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::UrlHelper
    include WillPaginate::ViewHelpers
    
    def report
      options.report
    end
    
    def user
      options.user
    end
  end
  
  formatter :csv do
    build :assessment do
      return if data.size.zero?

      data.add_column('Username', :before => "First Name") do |r|
        User.find(r['user_id'], :select => :username).username
      end

      # Remove attempts from output. Must be a cleaner way of doing this
      data.each_with_index do |row, i|
        row.to_a[5..-1].each_with_index do |column, j|
          data[i][j + 5] = (column.blank? || column.to_i < 0) ? nil : column.split('<br/>').andand[0]
        end
      end

      # Finally, drop the user_id column
      data.remove_column('user_id')

      output << data.to_csv
    end
  end

  formatter :pdf do |t|
    build :assessment do
      return if data.size.zero?

      title             = 'Assessment Report'
      max_column_width  = ((PAGE_WIDTH - 225) / MAX_DATA_COLUMNS)

      # Configure the display options for the report
      user_column_options = {
        'First Name'    => { :width => 75, :justification => :left },
        'Last Name'     => { :width => 75, :justification => :left },
        'Student ID'    => { :width => 75, :justification => :left }
      }

      options.paper_size        = 'A4'
      options.paper_orientation = :landscape
      options.table_format = {
        :heading_font_size => 8,
        :bold_headings     => true,
        :shade_headings    => true,
        :font_size         => 8,
        :width             => 0,
        :maximum_width     => 0
      }

      pdf_writer.margins_mm(6, 6, 10)
      pdf_writer.start_page_numbering(400, 12, 8, :center, "Page <PAGENUM> of <TOTALPAGENUM>")

      column_names              = data.column_names
      user_column_names         = column_names[1..3]  # exclude 'user_id'
      user_column_names_length  = user_column_names.length

      data.rename_columns{ |c| c.gsub(/\|(P\d)/, ' (\1)') }

      # For this report we want a maximum of MAX_DATA_COLUMNS data columns
      column_names[(user_column_names_length + 1) .. -1].each_slice(MAX_DATA_COLUMNS) do |data_column_names|
        
        # Print the header information for *this* page
        move_cursor(top_boundary)
        pad_bottom(10) {
          add_text "<b>Assessment Report</b>", :font_size => 11, :justification => :left
          add_text "Generated for #{user.fullname} of #{user.client.client_name} on #{DateTime.now.to_formatted_s(:long_ordinal)}", :font_size => 9, :justification => :left
        }

        move_cursor(top_boundary)
        pad_bottom(10) {
          add_text "<b>CDX Online</b>",       :font_size => 11, :justification => :right
          add_text report.menu_version.to_s,  :font_size => 9,  :justification => :right
        }

        # Select a sub-part of the full table
        table = data.sub_table(user_column_names + data_column_names)

        # Add display options for the columns on *this* page
        column_options = {}
        data_column_names.each do |c|
          column_options[c] = { :width          => max_column_width, 
                                :justification  => :center }
        end

        # Format the cell data if not empty
        table.each_with_index do |row, i|
          row.to_a[user_column_names_length .. -1].each_with_index do |column, j|
            table[i][j + user_column_names_length] = (column.blank? || column.to_i < 0) ? nil : column.gsub(/<br\/>/, "\n")
          end
        end

        # Output the table
        draw_table(table, :width          => PAGE_WIDTH, 
                          :column_options => user_column_options.merge(column_options))

        pdf_writer.start_new_page if (data_column_names.size == MAX_DATA_COLUMNS)
      end
    end
  end

end

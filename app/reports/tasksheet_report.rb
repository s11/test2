# 
#  tasksheet.rb
#  report_rework
#  
#  Created by John Meredith on 2008-04-09.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class TasksheetReport < Ruport::Controller
  
  COLUMNS             = %w(username tasksheet_count name)
  INDIVIDUAL_COLUMNS  = %w(tasksheet_number description priority reference completed_on grade)
  NATEF_PRIORITIES    = %w(P1 P2 P3)
  MAX_DATA_COLUMNS    = 9
  PAGE_WIDTH          = 800

  stage :tasksheet

  def setup
    self.data = options.report.ruport_table
  end
  
  module Helpers
    def report
      options.report
    end

    def individual
      options.individual
    end
    
    def client
      options.client
    end
    
    def user
      options.user
    end

    def format_cell(data)
      return if data.blank?

      if data =~ /|/
        area, percentage = data.split('|').map(&:to_f)
      else
        percentage = data
      end
      "%0.1f%%" % (percentage || 0)
    end

    def bar_graph(percentage, priority, type = :integer)
      case priority
        when :p1
          required_percentage = 95
        when :p2
          required_percentage = 85
        when :p3
          required_percentage = 50
      end

      label = "%0.1f%%" % percentage

      output = "<div class='tasksheet'>"

      # Change the colour of the bar depending on whether the criteria has been met
      output << "<div class='graph'>"
      if percentage.to_i >= required_percentage
        output << image_tag('/images/lime_pixel.gif', :height => "20px", :width => "%d%%" % percentage, :alt => '')
      else
        output << image_tag('/images/tangerine_pixel.gif', :height => "20px", :width => "%d%%" % percentage, :style => "min-width: 1px", :alt => '')
        
        if (required_percentage - percentage.to_i) > 0
          output << image_tag('/images/banana_pixel.gif', :height => "20px", :width => "%d%%" % (required_percentage - percentage.to_i), :alt => '')
        end
      end
      output << "</div>"

      output << content_tag(:div, label, :class => "label")
      output << "</div>"
    end
  end

  formatter :csv do |t|
    build :tasksheet do
      return if data.size.zero?

      data.add_column('Username', :before => "First Name") do |r|
        User.find(r['user_id'], :select => :username).username
      end

      # Remove attempts from output. Must be a cleaner way of doing this
      data.each_with_index do |row, i|
        row.to_a[5..-1].each_with_index do |column, j|
          data[i][j + 5] = (column.blank? ? nil : format_cell(column))
        end
      end

      # Finally, drop the user_id column
      data.remove_column('user_id')

      output << data.to_csv
    end
  end

  formatter :pdf do |t|
    build :tasksheet do
      
      if individual.blank?

        title             = 'Tasksheet Report'
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

        pdf_writer.margins_mm(6)
        pdf_writer.start_page_numbering(400, 12, 8, :center, "Page <PAGENUM> of <TOTALPAGENUM>")

        column_names              = data.column_names
        user_column_names         = column_names[1..3]  # exclude 'user_id'
        user_column_names_length  = user_column_names.length

        RAILS_DEFAULT_LOGGER.debug(column_names.inspect)
        RAILS_DEFAULT_LOGGER.debug(user_column_names.inspect)

        data.rename_columns{ |c| c.gsub(/\|(P\d)/, ' (\1)') }

        # For this report we want a maximum of MAX_DATA_COLUMNS data columns
        column_names[(user_column_names_length + 1) .. -1].each_slice(MAX_DATA_COLUMNS) do |data_column_names|

          move_cursor(top_boundary)
          pad_bottom(10) {
            add_text "<b>#{title}</b>", :font_size => 11, :justification => :left
            add_text "Generated for #{user.fullname} of #{user.client.client_name} on #{DateTime.now.to_formatted_s(:long_ordinal)}", :font_size => 9, :justification => :left
          }

          move_cursor(top_boundary)
          pad_bottom(10) {
            add_text "<b>CDX Online</b>",       :font_size => 11, :justification => :right
            add_text report.menu_version.to_s,  :font_size => 9,  :justification => :right
          }

          # Select a sub-part of the full table
          table = data.sub_table(user_column_names + data_column_names)

          column_options = {}
          data_column_names.each do |c|
            column_options[c] = { :width          => max_column_width, 
                                  :justification  => :center }
          end

          table.each_with_index do |row, i|
            row.to_a[user_column_names_length .. -1].each_with_index do |column, j|
              table[i][j + user_column_names_length] = (column.blank? ? nil : format_cell(column))
            end
          end
          
          # Create a summary / footer row

          # Output the table
          draw_table(table, :width          => 800, 
                            :column_options => user_column_options.merge(column_options))

          pdf_writer.start_new_page if (data_column_names.size == MAX_DATA_COLUMNS)
        end
      else
        options.paper_size        = 'A4'
        options.paper_orientation = :portrait
        options.style             = :justified
        options.table_format = {
          :heading_font_size => 8,
          :bold_headings     => false,
          :shade_headings    => true,
          :heading_font_size => 9,
          :font_size         => 8,
          :width             => 0
        }

        title = "Tasksheet Report for #{user.client.users.find_by_username(individual).fullname}"

        move_cursor(top_boundary)
        pad_bottom(10) {
          add_text "<b>#{title}</b>", :font_size => 11, :justification => :left
          add_text "Generated for #{user.fullname} of #{user.client.client_name} on #{DateTime.now.to_formatted_s(:long_ordinal)}", :font_size => 9, :justification => :left
        }

        move_cursor(top_boundary)
        pad_bottom(10) {
          add_text "<b>CDX Online</b>", :font_size => 11, :justification => :right
          add_text "v5.0", :font_size => 9, :justification => :right
        }

        render_grouping data, options.to_hash.merge(:formatter => pdf_writer)
      end
    end
  end
end
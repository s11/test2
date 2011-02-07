# 
#  activity.rb
#  report_rework
#  
#  Created by John Meredith on 2008-04-09.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class ActivityReport < Ruport::Controller

  MAX_DATA_COLUMNS = 9
  PAGE_WIDTH       = 800

  stage :activity

  def setup
    self.data = options.report.ruport_table
  end

  module Helpers
    def report
      options.report
    end

    def user
      options.user
    end

    def format_cell(data)
      data = data.to_i

      hours   = data / 3600
      minutes = (data % 3600) / 60
      seconds = (data % 3600) % 60

      '%0.2d:%0.2d:%0.2d' % [hours, minutes, seconds]
    end
  end

  formatter :csv do |t|
    build :activity do
      return if data.size.zero?

      data.add_column('Username', :before => "First Name") do |r|
        User.find(r['user_id'], :select => :username).username
      end
      
      # Add a total time column for each student
      data.add_column('Total Time') do |r|
        total = r.to_a[4..-1].map{|c| c.to_i}.sum
        total == 0 ? nil : total
      end

      # Finally, drop the user_id column
      data.remove_column('user_id')
      
      output << data.to_csv
    end
  end

  formatter :pdf do |t|
    build :activity do
      return if data.size.zero?

      title             = "Activity Report"
      max_column_width  = ((PAGE_WIDTH - 225) / MAX_DATA_COLUMNS)

      # Configure the display options for the report
      user_column_options = {
        'First Name'    => { :width => 75, :justification => :left },
        'Last Name'     => { :width => 75, :justification => :left },
        'Student ID'    => { :width => 75, :justification => :left }
      }

      options.paper_size        = 'A4'
      options.paper_orientation = :landscape
      options.table_format      = {
        :heading_font_size => 8,
        :bold_headings     => true,
        :shade_headings    => true,
        :font_size         => 8,
        :width             => 0,
        :maximum_width     => 0
      }

      pdf_writer.margins_mm(6, 6, 8, 6)
      pdf_writer.start_page_numbering(400, 12, 8, :center, "Page <PAGENUM> of <TOTALPAGENUM>")

      column_names              = data.column_names
      user_column_names         = column_names[1..3]  # exclude 'user_id'
      user_column_names_length  = user_column_names.length

      # Add a total time column for each student
      data.add_column('Total Time') do |r|
        total = r.to_a[(user_column_names_length + 1) .. -1].map{|c| c.to_i}.sum
        total == 0 ? nil : total
      end

      # For this report we want a maximum of MAX_DATA_COLUMNS data columns
      column_names[(user_column_names_length + 1) .. -1].each_slice(MAX_DATA_COLUMNS) do |data_column_names|

        # Print the header information for *this* page
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

        # Format the cell data if not empty
        table.each_with_index do |row, i|
          row.to_a[user_column_names_length .. -1].each_with_index do |column, j|
            table[i][j + user_column_names_length] = ((column.blank? or column.zero?) ? nil : format_cell(column))
          end
        end

        # Add display options for the columns on *this* page
        column_options = {}
        data_column_names.each do |c|
          column_options[c] = { :width          => max_column_width,
                                :justification  => :center }
        end
        
        # Add a summary row to the bottom of the table
        unless table.nil?
          summary = table.data.first.clone
          summary.attributes.each do |attr|
            if summary.attributes[0..1].include?(attr)
              summary.data[attr] = nil
            elsif summary.attributes[2].include?(attr)
              summary.data[attr] = '<b><i>Totals:</i></b>'
            else
              summary.data[attr] = '<b>' + format_cell(data.sigma(attr)).to_s + '</b>'
            end
          end
          table << summary
        end
        
        # Output the table
        draw_table(table, :width          => PAGE_WIDTH, 
                          :column_options => user_column_options.merge(column_options))

        pdf_writer.start_new_page if (data_column_names.size >= MAX_DATA_COLUMNS)
      end
    end
  end
end

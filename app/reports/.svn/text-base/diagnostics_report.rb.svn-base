# 
#  activity.rb
#  report_rework
#  
#  Created by John Meredith on 2008-04-09.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class DiagnosticsReport < Ruport::Controller

  MAX_DATA_COLUMNS = 9
  PAGE_WIDTH       = 800

  stage :diagnostics

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
      return nil if data.blank?

      bits = data.split('|')
      if bits[0].blank?
        '(%d of %d completed)' % bits[1..-1]
      else
        "%0.1f\n(%d of %d completed)" % bits
      end

    end

  end
  
  formatter :csv do |t|
    build :diagnostics do
      return if data.size.zero?

      data.add_column('Username', :before => "First Name") do |r|
        User.find(r['user_id'], :select => :username).username
      end
      
      # # Add a total time column for each student
      # data.add_column('Total Time') do |r|
      #   total = r.to_a[3..-1].map{|c| c.to_i}.sum
      #   total == 0 ? nil : total
      # end
      # 
      # data.each_with_index do |row, i|
      #   row.to_a[3..-1].each_with_index do |column, j|
      #     data[i][j + 3] = duration(column) unless column.blank?
      #   end
      # end

      # Finally, drop the user_id column
      data.remove_column('user_id')
      
      output << data.to_csv
    end
  end
  
  formatter :pdf do |t|
    build :diagnostics do
      return if data.size.zero?

      title             = 'Diagnostics Report'
      max_column_width  = (800 - 225) / MAX_DATA_COLUMNS

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
      
      pdf_writer.margins_mm(6, 6, 8, 6)
      pdf_writer.start_page_numbering(400, 12, 8, :center, "Page <PAGENUM> of <TOTALPAGENUM>")
      
      column_names              = data.column_names
      user_column_names         = column_names[1..3]  # exclude 'user_id'
      user_column_names_length  = user_column_names.length

      RAILS_DEFAULT_LOGGER.debug(column_names.inspect)
      RAILS_DEFAULT_LOGGER.debug(user_column_names.inspect)

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

        # Format the cell data to be more human readable
        table.each_with_index do |row, i|
          row.to_a[user_column_names_length .. -1].each_with_index do |column, j|
            table[i][j + user_column_names_length] = (column.blank? ? nil : format_cell(column))
          end
        end

        # Add display options for the columns on *this* page
        column_options = {}
        data_column_names.each do |c|
          column_options[c] = { :width          => max_column_width, 
                                :justification  => :center }
        end

        # Output the table
        draw_table(table, :width          => 800, 
                          :column_options => user_column_options.merge(column_options))

        pdf_writer.start_new_page if (data_column_names.size >= MAX_DATA_COLUMNS)
      end
    end
  end
end

#--
#  csv_files_controller.rb
#  management
#  
#  Created by John Meredith on 2009-08-19.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
require 'fastercsv'

class CsvFilesController < InheritedResources::Base
  actions :new, :create, :sample_csv_download

  CSV_COLUMNS      = %w{username password firstname lastname email student_id year_level}

  
  def create
    # We save the resource either way
    build_resource.save


    # For safety, get all the ids that belong to the current client
    class_group_ids = current_client.class_groups.all(:select => "id", :conditions => { :id => params[:class_groups] }).map(&:id) if params[:class_groups].present?

    
    if resource.csv.path.blank?
      flash[:error] = "You must select a CSV file to upload"
      redirect_to new_csv_file_path(:anchor => 'tab-import') and return
    end
    
    begin
      @csv_contents = FasterCSV.read(resource.csv.path, :headers => true, :return_headers => true)
      header_row = @csv_contents[0].to_hash.keys
    
      # Check that we have the correct number of columns
      if header_row.size != CSV_COLUMNS.size
        flash[:error] = "An error occured whilst parsing the uploded CSV file: The number of columns don't match those in the example CSV template. Please check your CSV file again."
        redirect_to new_csv_file_path(:anchor => 'tab-import') and return
      end
          
      # Check the header row to ensure it's sane
      unless (header_row - CSV_COLUMNS).empty?
        flash[:error] = "An error occured whilst parsing the uploded CSV file: Columns names don't match those in the example CSV template. Please check your CSV file again."
        redirect_to new_csv_file_path(:anchor => 'tab-import') and return
      end
          
      # Check that there are enough logons available, otherwise bail
      if (@csv_contents.size - 1) > current_client.remaining_students
        if current_client.remaining_students == 0
          flash[:error] = "All the student acounts allocated to this account have been taken."
        else
          flash[:error] = "You have attempted to upload more students than are currently available on this account. Please remove some students first before attempting this operation again."
        end
    
        redirect_to new_csv_file_path(:anchor => 'tab-import') and return
      end
          
      # Remove the header row from the parsed CSV file
      @csv_contents.delete(0)
          
      @csv_contents.each_with_index do |row, i|
        row_hash = row.to_hash
          
        # Adjust the row to allow for proper password validation
        row_hash['password']              = row['password'].andand.strip
        row_hash['password_confirmation'] = row['password'].andand.strip
          
        user = current_client.students.find_or_initialize_by_username(row_hash['username'])
        user.csv_line_number = i + 1
          
        if user.new_record?
          user.attributes = row_hash
          user.class_group_ids = class_group_ids if class_group_ids.present?
          if user.save
            flash[:students_created] ||= []
            flash[:students_created] << user.try(:username)
          else
            flash[:students_invalid] = []
            flash[:students_invalid] << user.try(:username)
          end
        else
          flash[:students_duplicate] ||= []
          flash[:students_duplicate] << user.try(:username)
        end
      end
    rescue FasterCSV::MalformedCSVError => err
      flash[:error] = "An error occured whilst parsing the uploaded CSV file: #{err.message}"
      redirect_to new_csv_file_path(:anchor => 'tab-import') and return
    end
    
    # Hack to get the new.html.haml tmeplate to render
    @csv_file = nil

    build_resource
    redirect_to new_csv_file_path(:anchor => 'tab-import')
  end


  # Will send the sample CSV file as an attachment (ie. browser download)
  def sample_csv_download
    send_file "#{RAILS_ROOT}/public/samples/sample_students.csv", :type => 'text/csv', :disposition => 'attachment'
  end


  protected
    # We're always in the context of the current client
    def begin_of_association_chain
      current_client
    end
end

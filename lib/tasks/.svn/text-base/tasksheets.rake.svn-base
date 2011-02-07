# 
#  tasksheets.rake
#  online
#  
#  Created by John Meredith on 2009-03-03.
#  Copyright 2009 CDX Global. All rights reserved.
# 
namespace :cdx do
  namespace :tasksheets do

    desc "Import a new NATEF standard into the tasksheet database from the CSVFILE"
    task :import => :environment do
      # Display usage information if CSVFILE has not been specified
      if ENV['CSVFILE'].blank?
        puts "Usage: rake cdx:tasksheets:import CSVFILE='path/to/somefile.csv'"
        exit
      end

      require 'fastercsv'

      FasterCSV.foreach(ENV['CSVFILE'], :headers => :first_row) do |row|
        tasksheet_number     = row['tasksheet_number'].squish.upcase
        tasksheet_title      = row['title'].squish
        tasksheet_short_name = row['short_name'].squish

        tasksheet = Tasksheet.find_by_number(tasksheet_number)

        # Is the tasksheet exists, check the title and short name; otherwise
        # create a new tasksheet
        unless tasksheet.blank?
          if tasksheet.title.squish != tasksheet_title
            puts "[#{tasksheet_number}] Title doesn't match. Skipping."
            puts "\tOld: |#{tasksheet.title.squish}|"
            puts "\tNew: |#{tasksheet_title}|"
            puts
            next
          end

          # We don't mind if the shortname changes as it's CDX assigned so
          # update it if it has.
          if tasksheet.short_name.squish != tasksheet_short_name
            tasksheet.short_name = tasksheet_short_name
            tasksheet.save
          end
        else
          tasksheet = Tasksheet.new(:title => tasksheet_title, :short_name => tasksheet_short_name)
          tasksheet.number = tasksheet_number
        
          unless tasksheet.save
            puts "[#{tasksheet_number}] Creation failed. (#{tasksheet.errors.to_yaml})"
          end
        end
        
        # Add tasksheet to new 2008 NATEF standard
        cert = returning(tasksheet.certifications.new(:version => 2008)) do |cert|
          cert.title                  = tasksheet.title
          cert.natef_reference        = row['natef_reference'].andand.squish
          cert.natef_priority         = row['natef_priority'].andand.squish
          cert.description            = "ASE #{row['ase_area'].andand.squish}: #{row['ase_area_description'].titleize}".gsub(/\sAnd\s/, ' and ')
          cert.section_description    = row['section_description'].andand.squish
          cert.subsection             = row['subsection'].andand.squish
          cert.subsection_description = row['subsection_description'].andand.squish
        end
        
        puts cert.errors.to_yaml unless cert.save
      end
    end

  end
end

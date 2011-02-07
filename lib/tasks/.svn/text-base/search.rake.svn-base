#--
#  search.rake
#  management
#  
#  Created by John Meredith on 2009-08-04.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
namespace :cdx do
  namespace :search do
    namespace :clear do
      desc "Clear all tasksheets search content"
      task :tasksheets => :environment do
        Tasksheet.update_all("search_content=NULL")
      end

      desc "Clear all topic search content"
      task :topics => :environment do
        Topic.update_all("search_content=NULL")
      end

      desc "Clear all topic search content"
      task :all => [:tasksheets, :topics]
    end
    
    namespace :build do
      desc "Import Tasksheet PDF content for search"
      task :tasksheets => :environment do
        Tasksheet.transaction do
          Tasksheet.find_each do |tasksheet|
            filename = "#{RAILS_ROOT}/public/assets/TS/#{tasksheet.number}.pdf"
      
            if File.exists?(filename)
              contents = `pdftotext -raw #{filename} -`.squish
              contents.gsub!(/Supervisor\/instructor\ssignature.*/, '')
              contents.gsub!(/\.+/, '.')
              contents.gsub!(/DVP\sLicensing\sPty\sLtd/, '')

              tasksheet.update_attributes!(:search_content => contents.squish)
              puts "Scraped `#{filename}` for tasksheet ##{tasksheet.id}"
            else
              puts "[ERROR] Tasksheet #{tasksheet.number}: assets/TS/#{tasksheet.number}.pdf not found"
            end
          end
        end
      end
    
      desc "Import Topic HTML content for search"
      task :topics => :environment do
        require 'hpricot'
      
        # Topics first.
        #
        # NOTE: Use transactions. One day this data might live in a real DB.
        Topic.transaction do
          Topic.paginated_each do |topic|
            filename = "#{RAILS_ROOT}/public/assets/html/#{topic.page_filename}"
            if File.exists?(filename)
              document = Hpricot(File.read(filename))
              
              # Remove all HTML to get the contents
              contents = document.inner_text.squish

              # Grab the summary
              summary = (document/'#summary #summarytxt').inner_text.squish

              topic.update_attributes!(:search_content => contents, :summary => summary)
              puts "Scraped `#{filename}` for topic ##{topic.id} with summary `#{summary}`"
            else
              puts "[ERROR] Topic #{topic.id}: assets/html/#{topic.page_filename} not found"
            end
          end
        end
      end

      desc "Import all tasksheet and topic content for search"
      task :all => [:tasksheets, :topics]
    end
  end
end
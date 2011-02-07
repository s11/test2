#--
#  content.rake
#  management
#  
#  Created by John Meredith on 2009-08-04.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
namespace :cdx do
  namespace :content do

    desc "WARNING: Empty all the NewWorld (tm) tables"
    task :empty => :environment do
      puts "Clearing NewWorldOrder tables..."

      [Menu, MenuVersion, Category, Topic, CategoryItem].each do |clazz| 
        clazz.connection.execute("TRUNCATE #{clazz.table_name}")
        puts "  `#{clazz.table_name}` truncated"
      end

      #... and make sure the category_item reference on log tables is blank
      ClientuserLog.update_all("category_item_id=NULL")
      puts "  `clientuser_log`.`category_item_id` cleared"

      TopicLog.update_all("category_item_id=NULL")
      puts "  `log_topics`.`category_item_id` nullified"
    end

    desc "Convert from the old content DB schema to the new streamlined version"
    task :convert => [:empty] do
      # Import the menus
      # 
      # NOTE: It's vitally important that the id be carried across as the live MySQL DB's have different auto increments set
      Menu.connection.execute "INSERT INTO menus (id, name, custom, iso3166) SELECT menu_id, TRIM(name), NOT globally_accessible, TRIM(iso3166) FROM content_50.menus"

      Content::Menu.all.each do |old_menu|
        puts "Converting menu: #{old_menu.menu_name}..."

        menu = Menu.find(old_menu.id)

        # v41 conversion
        if old_menu.version_41?
          puts "\tProcessing v41 content..."

          # Create the menu version and proceed to convert all the children
          version = menu.versions.create!(:version => 41, :moodle_course_category_id => old_menu.read_attribute(:moodle_course_category_v41))

          Content::Category.find_by_sql("SELECT * FROM content_db.#{old_menu.category_table} WHERE parent_id IS NULL ORDER BY category_id ASC").each do |old_category|
            convert_content_category(old_menu, version, old_category)
          end
        end

        # v50 conversion
        if old_menu.version_50?
          puts "\tProcessing v50 content..."

          # Create the menu version and proceed to convert all the children
          version = menu.versions.create!(:version => 50, :moodle_course_category_id => old_menu.read_attribute(:moodle_course_category_v50))

          Content::Category.find_by_sql("SELECT * FROM content_50.#{old_menu.category_table} WHERE parent_id IS NULL ORDER BY category_id ASC").each do |old_category|
            convert_content_category(old_menu, version, old_category)
          end
        end
      end
    end

  end
end

# Recursively converts categories into new format
def convert_content_category(old_menu, version, old_category, parent_category = nil, level = 0)
  database_name = "content_50"
  database_name = "content_db" if version.version == 41
  
  # Create the new category record
  new_category      = version.categories.build
  new_category.name = old_category.category_menu_name
  new_category.kind = case old_category.category_color
    when 'Green'
      'theory'
    when 'Red'
      'procedure'
    when '#483293'
      'assessment'
    when '#333333'
      'information'
  end
  new_category.save!
  
  # If it has a parent, make it a child of the parent
  new_category.move_to_child_of(parent_category) unless parent_category.nil?
  puts "\t#{' ' * 2 * (level + 2)}#{new_category.name} [#{new_category.id}]"
  
  # Iterate through each child converting as we go.
  Content::Category.find_by_sql("SELECT * FROM #{database_name}.#{old_menu.category_table} WHERE parent_id=#{old_category.id} AND menu_id=#{old_menu.menu_id} ORDER BY category_id ASC").each do |old_category_child|
    convert_content_category(old_menu, version, old_category_child, new_category, level + 1)
  end
  
  # If the category has topics, then copy them across
  Content::Topic.find_by_sql("SELECT * FROM #{database_name}.#{old_menu.content_table} WHERE category_id=#{old_category.category_id} ORDER BY publish_topic_id ASC").each do |old_topic|
    if result = old_topic.htmlelement.match(/^(C\d{3})\.pdf$/)
  
      if Tasksheet.exists?(:number => result[1])
        tasksheet = Tasksheet.find_by_number(result[1])
        category_item = new_category.items.new(:item => tasksheet, :legacy_publish_topic_id => old_topic.publish_topic_id)
        if category_item.valid?
          category_item.save!
          puts "\t#{' ' * 2 * (level + 3)} Tasksheet: #{tasksheet.number} [#{category_item.item_id}, #{category_item.item_type}]"
        else
          puts "\t#{' ' * 2 * (level + 3)}[ERROR] Duplicate tasksheet: #{tasksheet.number}, ID:#{tasksheet.id}"
        end
      else
        puts "\t#{' ' * 2 * (level + 3)}[ERROR] Tasksheet `#{result[1]}` not found for category.id=#{new_category.id} "
      end
  
    else
      
      # Determine the topic type
      topic = Topic.find_or_initialize_by_page_filename(old_topic.htmlelement)
      case old_topic.topiccolor
        when 'Green'
          topic.kind = 'theory'
        when 'Red'
          topic.kind = 'procedure'
        when '#483293'
          topic.kind = 'assessment'
        when '#333333'
          topic.kind = 'information'
        else
          puts "\t#{' ' * 2 * (level + 3)}[ERROR] Unknown topic kind: #{old_topic.topiccolor} [#{old_topic.publish_topic_id}]"
          next
      end
  
      if topic.new_record?
        topic.name          = old_topic.topicname.strip.gsub(/^\**\s*/, '')
        topic.description   = old_topic.topicdescription.strip.gsub(/^\**\s*/, '')
        topic.page_filename = old_topic.htmlelement.strip.gsub(/^\**\s*/, '')
  
        topic.has_video = (old_topic.mpegelement == '1')
        
        # DVOM's are special it seems
        # if old_topic.dvomelement == '1'
        #   topic.page_filename = topic.dvom_filename = "#{old_topic.htmlelement[0..-8]}.html" 
        # end
  
        topic.page_filename                     = old_topic.htmlelement
        topic.knowledge_check_filename          = old_topic.htmlelement.gsub(/(_2)?\.html$/, '_kc.html')    if old_topic.kcelement == '1'
        topic.workshop_procedure_guide_filename = old_topic.htmlelement.gsub(/(_2)?\.html$/, '_WS\1.pdf')   if old_topic.wselement == '1'
        topic.assessment_checklist_filename     = old_topic.htmlelement.gsub(/\.html/, '_AC.pdf')           if old_topic.acelement == '1'
  
        topic.save!
      end
  
  
      category_item = new_category.items.new(:item => topic, :legacy_publish_topic_id => old_topic.publish_topic_id)
  
      # DVOM and HA's have moved to the CategoryItem
      category_item.dvom_filename = old_topic.htmlelement.gsub(/(_2)?\.html$/, '')  if (old_topic.dvomelement == '1')
      category_item.handout_activity_sheet_filename = old_topic.haelement           if old_topic.haelement.present?
  
      if category_item.valid?
        category_item.save!
        puts "\t#{' ' * 2 * (level + 3)} Topic: #{topic.name} [#{category_item.item_id}, #{category_item.item_type}]"
      else
        puts "\t#{' ' * 2 * (level + 3)}[ERROR] Duplicate topic: #{old_topic.topicname}, ID:#{old_topic.publish_topic_id}"
      end
    end
  end
end

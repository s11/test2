#--
#  content_helper.rb
#  management
#  
#  Created by John Meredith on 2009-08-19.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
module ContentHelper

  # For the given category and category item, return the previous item in the list (or nothing)
  def previous_category_item_path(category, item)
    result = Category.find_by_sql(["SELECT ci.id FROM categories AS c  JOIN categories_items AS ci ON c.id=ci.category_id WHERE c.menu_version_id=? AND ci.id < ? ORDER BY c.lft ASC, ci.position ASC LIMIT 1", current_menu_version.id, category_item.id])

    if result.present?
      item = CategoryItem.find(result.first)
      if item.item_type == "Topic"
        return  category_topic_path(item.category, item.item)
      end
    end

    '#'
  end

  # For the given category and category item, return the next item in the list (or nothing)
  def next_category_item_path(category, item)
    result = Category.find_by_sql(["SELECT ci.id FROM categories AS c  JOIN categories_items AS ci ON c.id=ci.category_id WHERE c.menu_version_id=? AND ci.id > ? ORDER BY c.lft ASC, ci.position ASC LIMIT 1", current_menu_version.id, category_item.id])
    
    if result.present?
      item = CategoryItem.find(result.first)
      if item.item_type == "Topic"
        return  category_topic_path(item.category, item.item)
      end
    end

    '#'
  end
  
end
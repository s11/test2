#--
#  20091012065238_replace_content_lookup_view_with_table.rb
#  management
#  
#  Created by John Meredith on 2009-10-12.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class ReplaceContentLookupViewWithTable < ActiveRecord::Migration
  def self.up
    # Rename the old table
    rename_table :content_lookup, :deprecated_content_lookup
    
    # Create a new table from old table
    execute "CREATE TABLE content_lookup AS select `m`.`id` AS `menu_id`, `mv`.`version` AS `version`, `ci`.`legacy_publish_topic_id` AS `publish_topic_id`, `ci`.`id` AS `category_item_id` from (((`menus` `m` join `menu_versions` `mv` on((`mv`.`menu_id` = `m`.`id`))) join `categories` `c` on((`c`.`menu_version_id` = `mv`.`id`))) join `categories_items` `ci` on((`ci`.`category_id` = `c`.`id`))) group by `m`.`id`,`mv`.`version`,`ci`.`legacy_publish_topic_id` having (`mv`.`version` in (41,50))"
    add_index :content_lookup, [:menu_id, :version, :publish_topic_id], :unique => true, :name => :idx_unique
  end

  def self.down
    drop_table    :content_lookup
    rename_table  :deprecated_content_lookup, :content_lookup
  end
end

#--
#  20091228034529_enable_print_support_for_alberta_menu.rb
#  management
#  
#  Created by John Meredith on 2009-12-28.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class EnablePrintSupportForAlbertaMenu < ActiveRecord::Migration
  def self.up
    menu = Menu.find_by_name!('Alberta')
    menu_version = menu.versions.find_by_version!(51)
    menu_version.update_attributes!(:has_print_support => true)
  end

  def self.down
    menu = Menu.find_by_name!('Alberta')
    menu_version = menu.versions.find_by_version!(51)
    menu_version.update_attributes!(:has_print_support => false)
  end
end

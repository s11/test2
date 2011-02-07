#--
#  buttons_helper.rb
#  management
#  
#  Created by John Meredith on 2009-08-12.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
module ButtonsHelper
  def reset_button_tag(name = "Undo Changes")
    content_tag :button, name, {:class => "ui-button ui-widget ui-state-default ui-button-size-normal ui-button-orientation-l ui-corner-all ui-button-arrowreturnthick-1-w", :name => "reset", :type => 'reset'}
  end

  def create_button_tag(name = "Create")
    content_tag :button, name, {:class => "ui-button ui-widget ui-state-default ui-button-size-normal ui-button-orientation-l ui-corner-all ui-button-check", :name => "commit", :type => 'submit'}
  end

  def update_button_tag(name = "Save Changes")
    content_tag :button, name, {:class => "ui-button ui-widget ui-state-default ui-button-size-normal ui-button-orientation-l ui-corner-all ui-button-disk", :name => "update", :type => 'submit'}
  end

  def save_button_tag(name = "Save Changes")
    content_tag :button, name, {:class => "ui-button ui-widget ui-state-default ui-button-size-normal ui-button-orientation-l ui-corner-all ui-button-disk", :name => "save", :type => 'submit'}
  end

  def save_and_copy_button_tag(name = "Save & Copy")
    content_tag :button, name, {:class => "ui-button ui-widget ui-state-default ui-button-size-normal ui-button-orientation-l ui-corner-all ui-button-disk", :name => "saveandcopy", :type => 'submit'}
  end

  def search_button_tag(name = "Search")
    content_tag :button, name, {:class => "ui-button ui-widget ui-state-default ui-button-size-normal ui-button-orientation-l ui-corner-all ui-button-search", :type => 'submit'}
  end

  def delete_button_tag(name = "Delete")
    content_tag :button, name, {:class => "ui-button ui-widget ui-state-default ui-button-size-normal ui-button-orientation-l ui-corner-all ui-button-trash", :name => "delete", :type => 'submit'}
  end

  def send_button_tag(name = "Create")
    content_tag :button, name, {:class => "ui-button ui-widget ui-state-default ui-button-size-normal ui-button-orientation-l ui-corner-all ui-button-arrowthick-1-e", :name => "commit", :type => 'submit'}
  end
end

# == Schema Information
# Schema version: 20091007002944
#
# Table name: menus
#
#  id                   :integer(4)      not null, primary key
#  name                 :string(255)     not null
#  is_custom            :boolean(1)      default(TRUE), not null
#  iso3166              :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  deleted_at           :datetime
#  lock_version         :integer(4)      default(1), not null
#  is_client_locked     :boolean(1)
#  has_natef_selection  :boolean(1)
#  has_custom_dashboard :boolean(1)
#

#--
#  menu.rb
#  management
#  
#  Created by John Meredith on 2009-05-18.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class Menu < ActiveRecord::Base
  # Behaviours ---------------------------------------------------------------------------------------------------------------------
  acts_as_reportable :only => [:name, :is_custom], :include => "versions"



  # Associations -------------------------------------------------------------------------------------------------------------------
  has_many :versions, :class_name => "MenuVersion"


  
  # Validations --------------------------------------------------------------------------------------------------------------------
  validates_presence_of :name



  # Scopes -------------------------------------------------------------------------------------------------------------------------
  default_scope :conditions => "#{table_name}.deleted_at IS NULL OR #{table_name}.deleted_at > UTC_TIMESTAMP()"

  # A global menu does not include GS. It is those menus which the client can switch between.
  named_scope :global,        :conditions => { :is_custom => false, :is_client_locked => false  }
  


  # Callbacks ----------------------------------------------------------------------------------------------------------------------
  before_destroy { |record| MenuVersion.destroy_all("menu_id=#{record.id}")}



  # Override display in string context
  def to_s
    name
  end

  # Returns true if the map has a version given by version
  def has_version?(version)
    versions.exists?(:version => version)
  end

  # Mark the model deleted_at as now.
  def destroy_without_callbacks
    self.class.update_all("deleted_at=UTC_TIMESTAMP()", "id = #{self.id}")
    self
  end

  # Override the default destroy to allow us to flag deleted_at.
  # This preserves the before_destroy and after_destroy callbacks.
  # Because this is also called internally by Model.destroy_all and
  # the Model.destroy(id), we don't need to specify those methods
  # separately.
  def destroy
    return false if callback(:before_destroy) == false
    result = destroy_without_callbacks
    callback(:after_destroy)
    self
  end
end

# == Schema Information
# Schema version: 20091007002944
#
# Table name: client_properties
#
#  id            :integer(4)      not null, primary key
#  client_prefix :string(4)       not null
#  key           :string(64)      not null
#  value         :string(255)     not null
#  created_at    :datetime
#  updated_at    :datetime
#  deleted_at    :datetime
#  lock_version  :integer(4)      default(0)
#  value_type    :string(255)     default("boolean")
#  client_id     :integer(4)
#

#
# client_property.rb
# online_trunk
# 
# Created by John Meredith on 2008-04-03.
# Copyright 2008 CDX Global. All rights reserved.
# 
# TODO: STI this class
#
class Old::ClientProperty < ActiveRecord::Base
  ALLOWED_PROPERTIES = {
    :allow_menu_preference_change => 'boolean',
    :enable_colour_legend         => 'boolean',
    :enable_messaging             => 'boolean',
    :enable_search                => 'boolean',
    :enable_moodle                => 'boolean',
    :enable_video_selection       => 'boolean',
    :enable_supervisor_menu       => 'boolean',
    :enable_instructor_menu       => 'boolean',
    :enable_student_menu          => 'boolean',
    :enable_location_selection    => 'boolean',
    :content_version              => 'integer'    # Move to client record
  }


  # Attributes
  attr_accessible :key, :value, :value_type


  # Associations
  belongs_to :client
  

  # Validations
  validates_presence_of   :client_id, :key, :value, :value_type
  validates_associated    :client, :on => :create
  validates_uniqueness_of :key, :scope => :client_id, :on => :create


  # Scopes
  named_scope :boolean, :conditions => { :value_type => 'boolean' }


  # Returns true if ths property is boolean
  def boolean?
    value_type == 'boolean'
  end

  # Returns true if ths property is an integer
  def integer?
    value_type == 'integer'
  end

  # Returns true if the property is boolean and set to true
  def enabled?
    boolean? && value == 'true'
  end
  
  # Inverse of enabled?
  def disabled?
    !enabled?
  end
  
  # Toggles a boolean atttributes
  #
  # FIXME: Should throw an exception if the property is not boolean
  def toggle!
    return false unless boolean?

    self.value = enabled? ? "false" : "true"
    save!
  end
end

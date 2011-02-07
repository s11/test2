# == Schema Information
# Schema version: 20091007002944
#
# Table name: regions
#
#  id           :integer(4)      not null, primary key
#  region_type  :string(255)
#  code         :string(255)
#  name         :string(255)
#  country_id   :integer(4)      not null
#  parent_id    :integer(4)
#  lft          :integer(4)
#  rgt          :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#  deleted_at   :datetime
#  lock_version :integer(4)      default(1), not null
#

#
# region.rb
# online
#
# Created by John Meredith on 2008-08-19.
# Copyright 2008 CDX Global. All rights reserved.
#
class Region < ActiveRecord::Base
  # Behaviours
  acts_as_nested_set :scope => :country_id


  # Associations
  belongs_to :country


  # Validations
  validates_presence_of :code, :name, :region_type, :country_id
  validates_associated :country
  validates_uniqueness_of :code, :scope => [:country_id, :deleted_at]


  # Override destroy to just flag the record as deleted
  def destroy
    self.class.update_all("deleted_at=UTC_TIMESTAMP()", "id=#{attributes['id']}")
    readonly!
    freeze
  end

  # Returns true if this record has been deleted
  def deleted?
    !deleted_at.blank?
  end

  # Returns the name of the country in a string context
  def to_s
    name
  end
end

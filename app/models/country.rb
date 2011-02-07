# == Schema Information
# Schema version: 20091007002944
#
# Table name: countries
#
#  id            :integer(4)      not null, primary key
#  alpha_2_code  :string(255)     not null
#  alpha_3_code  :string(255)     not null
#  numeric_code  :integer(4)      not null
#  name          :string(255)     not null
#  official_name :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  deleted_at    :datetime
#  lock_version  :integer(4)      default(1), not null
#

# 
# country.rb
# online
# 
# Created by John Meredith on 2008-08-19.
# Copyright 2008 CDX Global. All rights reserved.
# 
class Country < ActiveRecord::Base
  # Associations
  has_many :regions


  # Validations
  #
  validates_presence_of   :alpha_2_code
  validates_uniqueness_of :alpha_2_code, :scope => :deleted_at
  validates_length_of     :alpha_2_code, :is => 2
  validates_presence_of   :alpha_3_code
  validates_uniqueness_of :alpha_3_code, :scope => :deleted_at
  validates_length_of     :alpha_3_code, :is => 3
  validates_presence_of   :numeric_code
  validates_uniqueness_of :numeric_code, :scope => :deleted_at


  # Override destroy to just flag the record as deleted
  #
  def destroy
    self.class.update_all("deleted_at=UTC_TIMESTAMP()", "id=#{attributes['id']}")
    readonly!
    freeze
  end

  # Returns true if this record has been deleted
  #
  def deleted?
    !deleted_at.blank?
  end
  
  # Returns the name of the country in a string context
  #
  def to_s
    name
  end
end

# == Schema Information
# Schema version: 20091007002944
#
# Table name: client_upgrades
#
#  id            :integer(4)      not null, primary key
#  client_prefix :string(4)       default(""), not null
#  from_version  :integer(4)      default(41), not null
#  to_version    :integer(4)      default(50), not null
#  created_at    :datetime
#  updated_at    :datetime
#  lock_version  :integer(4)      default(1), not null
#

# 
#  client_upgrades.rb
#  online
#  
#  Created by John Meredith on 2008-06-26.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class ClientUpgrades < ActiveRecord::Base
  # Versions of CDX Online that may be switched to / between
  VALID_VERSIONS = [41, 50]


  # Associations
  belongs_to :client, :foreign_key => "client_prefix"

  
  # Validations
  validates_presence_of   :client_prefix, :from_version, :to_version
  validates_uniqueness_of :client_prefix, :scope => :from_version
  validates_associated    :client
  validates_inclusion_of  :from_version, :in => VALID_VERSIONS
  validates_inclusion_of  :to_version,   :in => VALID_VERSIONS


  # Named scopes
  named_scope :latest, :order => "to_version ASC", :limit => 1
end

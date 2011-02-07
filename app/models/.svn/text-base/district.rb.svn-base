# == Schema Information
# Schema version: 20091007002944
#
# Table name: districts
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)     not null
#  client_count :integer(4)      default(0), not null
#  created_at   :datetime
#  updated_at   :datetime
#  deleted_at   :datetime
#  lock_version :integer(4)      default(1), not null
#

#--
#  district.rb
#  management
#  
#  Created by John Meredith on 2009-10-04.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class District < ActiveRecord::Base
  # Associations -------------------------------------------------------------------------------------------------------------------
  has_and_belongs_to_many :clients


  # Validations --------------------------------------------------------------------------------------------------------------------
  validates_presence_of   :name
  validates_uniqueness_of :name, :scope => :deleted_at
end

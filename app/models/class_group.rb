# == Schema Information
# Schema version: 20091007002944
#
# Table name: class_groups
#
#  id           :integer(4)      not null, primary key
#  client_id    :integer(4)      not null
#  name         :string(255)     not null
#  created_at   :datetime
#  updated_at   :datetime
#  deleted_at   :datetime
#  lock_version :integer(4)      default(1), not null
#

#--
#  class_group.rb
#  management
#  
#  Created by John Meredith on 2009-07-26.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class ClassGroup < ActiveRecord::Base
  # Behaviours ---------------------------------------------------------------------------------------------------------------------
  acts_as_reportable


  # Associations -------------------------------------------------------------------------------------------------------------------
  belongs_to  :client
  has_and_belongs_to_many :users
  has_many :tasksheet_submissions


  
  # Validations --------------------------------------------------------------------------------------------------------------------
  validates_presence_of   :client_id, :name
  validates_associated    :client
  validates_uniqueness_of :name, :scope => [:client_id, :deleted_at]



  # Convenience method to get all students for a group
  def students
    users.students
  end
  
  # Convenience method to get all instructors for a group
  #
  # NOTE: Instructors *includes* the supervisor
  def instructors
    users.not_students
  end
end

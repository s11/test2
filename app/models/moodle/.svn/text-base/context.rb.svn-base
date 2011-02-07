# == Schema Information
# Schema version: 20091007002944
#
# Table name: cdx_context
#
#  id           :integer(8)      not null, primary key
#  contextlevel :integer(8)      default(0), not null
#  instanceid   :integer(8)      default(0), not null
#

# 
#  context.rb
#  online
#  
#  Created by John Meredith on 2008-10-15.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class Moodle::Context < Moodle::Base
  set_table_name :cdx_context
  
  CONTEXT_SYSTEM    = 10 # the whole site
  CONTEXT_USER      = 30 # another user
  CONTEXT_COURSECAT = 40 # a course category
  CONTEXT_COURSE    = 50 # a course
  CONTEXT_MODULE    = 70 # an activity module
  CONTEXT_BLOCK     = 80 # a block
  
  # Associations
  has_many :role_assignments, :class_name => "Moodle::RoleAssignment", :foreign_key => "contextid"

  #
  # NOTE: The contextid of 50 is a Moodle designation that the context in question is a course
  #
  belongs_to :course, :class_name => "Moodle::Course", :foreign_key => "instanceid"
  
end

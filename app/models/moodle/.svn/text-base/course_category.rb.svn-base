# == Schema Information
# Schema version: 20091007002944
#
# Table name: cdx_course_categories
#
#  id           :integer(8)      not null, primary key
#  name         :string(255)     default(""), not null
#  description  :text(16777215)
#  parent       :integer(8)      default(0), not null
#  sortorder    :integer(8)      default(0), not null
#  coursecount  :integer(8)      default(0), not null
#  visible      :boolean(1)      default(TRUE), not null
#  timemodified :integer(8)      default(0), not null
#  depth        :integer(8)      default(0), not null
#  path         :string(255)     default(""), not null
#

# 
#  course_category.rb
#  online
#  
#  Created by John Meredith on 2008-03-18.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class Moodle::CourseCategory < Moodle::Base
  # We need to set the table name manually
  set_table_name :cdx_course_categories

  read_only = true                      # All models are read-only. We're just reporting.

  # Associations
  has_many :courses, :class_name => "Moodle::Course", :foreign_key => 'category'
end

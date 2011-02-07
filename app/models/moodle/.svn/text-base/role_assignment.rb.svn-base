# == Schema Information
# Schema version: 20091007002944
#
# Table name: cdx_role_assignments
#
#  id           :integer(8)      not null, primary key
#  roleid       :integer(8)      default(0), not null
#  contextid    :integer(8)      default(0), not null
#  userid       :integer(8)      default(0), not null
#  hidden       :boolean(1)      not null
#  timestart    :integer(8)      default(0), not null
#  timeend      :integer(8)      default(0), not null
#  timemodified :integer(8)      default(0), not null
#  modifierid   :integer(8)      default(0), not null
#  enrol        :string(20)      default(""), not null
#  sortorder    :integer(8)      default(0), not null
#

# 
#  role_assignment.rb
#  online
#  
#  Created by John Meredith on 2008-10-15.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class Moodle::RoleAssignment < Moodle::Base
  set_table_name :cdx_role_assignments

  # Associations
  belongs_to  :user,    :class_name => "Moodle::User",    :foreign_key => "userid"
  belongs_to  :context, :class_name => "Moodle::Context", :foreign_key => "contextid"
  belongs_to  :role,    :class_name => 'Moodle::Role',    :foreign_key => 'roleid'

  has_many    :courses, :class_name => "Moodle::Course",  :through => :context
  
end

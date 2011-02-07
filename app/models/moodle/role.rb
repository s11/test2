# == Schema Information
# Schema version: 20091007002944
#
# Table name: cdx_role
#
#  id          :integer(8)      not null, primary key
#  name        :string(255)     default(""), not null
#  shortname   :string(100)     default(""), not null
#  description :text(16777215)  default(""), not null
#  sortorder   :integer(8)      default(0), not null
#

# 
#  role.rb
#  online
#  
#  Created by John Meredith on 2008-10-15.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class Moodle::Role < Moodle::Base
  set_table_name :cdx_role
end

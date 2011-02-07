# == Schema Information
# Schema version: 20091007002944
#
# Table name: diagnostics_problems
#
#  id          :integer(4)      not null, primary key
#  system_id   :integer(4)      not null
#  description :string(255)     not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Diagnostics::Problem < ActiveRecord::Base
  set_table_name 'diagnostics_problems'

  belongs_to :system, :class_name => 'Diagnostics::System'
  # has_many :symptoms
  
  validates_presence_of :description
end

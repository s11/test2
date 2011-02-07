# == Schema Information
# Schema version: 20091007002944
#
# Table name: diagnostics_rectifications
#
#  id          :integer(4)      not null, primary key
#  system_id   :integer(4)      not null
#  description :string(255)     not null
#  result      :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Diagnostics::Rectification < ActiveRecord::Base
  set_table_name 'diagnostics_rectifications'

  belongs_to :system, :class_name => 'Diagnostics::System'
  # has_and_belongs_to_many :scenarios
  
  validates_presence_of :description
end

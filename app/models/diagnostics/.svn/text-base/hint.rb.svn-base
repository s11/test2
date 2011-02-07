# == Schema Information
# Schema version: 20091007002944
#
# Table name: diagnostics_hints
#
#  id             :integer(4)      not null, primary key
#  scenario_id    :integer(4)      not null
#  message        :string(255)     not null
#  classification :string(255)     not null
#  penalty        :integer(4)      default(1), not null
#  created_at     :datetime
#  updated_at     :datetime
#

class Diagnostics::Hint < ActiveRecord::Base
  set_table_name 'diagnostics_hints'
  
  belongs_to :scenario, :class_name => 'Diagnostics::Scenario'
  
  named_scope :verification, :conditions => ['classification = ?', 'verification']
  named_scope :identification, :conditions => ['classification = ?', 'identification']
  named_scope :rectification, :conditions => ['classification = ?', 'rectification']
  
end

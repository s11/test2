# == Schema Information
# Schema version: 20091007002944
#
# Table name: diagnostics_scenarios_rectifications
#
#  id               :integer(4)      not null, primary key
#  scenario_id      :integer(4)      not null
#  rectification_id :integer(4)      not null
#  rating           :integer(4)      not null
#  result           :string(255)
#  pass             :boolean(1)      not null
#  created_at       :datetime
#  updated_at       :datetime
#

class Diagnostics::ScenariosRectification < ActiveRecord::Base
  set_table_name 'diagnostics_scenarios_rectifications'

  belongs_to :scenario,       :class_name => 'Diagnostics::Scenario'
  belongs_to :rectification,  :class_name => 'Diagnostics::Rectification'
end

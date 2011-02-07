# == Schema Information
# Schema version: 20091007002944
#
# Table name: diagnostics_scenarios_identifications
#
#  id                :integer(4)      not null, primary key
#  scenario_id       :integer(4)      not null
#  identification_id :integer(4)      not null
#  rating            :integer(4)      not null
#  result            :string(255)
#  pass              :boolean(1)      not null
#  created_at        :datetime
#  updated_at        :datetime
#

class Diagnostics::ScenariosIdentification < ActiveRecord::Base
  set_table_name 'diagnostics_scenarios_identifications'

  belongs_to :scenario,       :class_name => 'Diagnostics::Scenario'
  belongs_to :identification, :class_name => 'Diagnostics::Identification'
end

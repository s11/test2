# == Schema Information
# Schema version: 20091007002944
#
# Table name: diagnostics_scenarios_symptoms
#
#  id          :integer(4)      not null, primary key
#  scenario_id :integer(4)      not null
#  symptom_id  :integer(4)      not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Diagnostics::ScenariosSymptom < ActiveRecord::Base
  set_table_name 'diagnostics_scenarios_symptoms'

  belongs_to :scenario, :class_name => 'Diagnostics::Scenario'
  belongs_to :symptom,  :class_name => 'Diagnostics::Symptom'
end

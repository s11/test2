# == Schema Information
# Schema version: 20091007002944
#
# Table name: diagnostics_scenarios_verifications
#
#  id              :integer(4)      not null, primary key
#  scenario_id     :integer(4)      not null
#  verification_id :integer(4)      not null
#  rating          :integer(4)      not null
#  result          :string(255)
#  pass            :boolean(1)      not null
#  created_at      :datetime
#  updated_at      :datetime
#

class Diagnostics::ScenariosVerification < ActiveRecord::Base
  set_table_name 'diagnostics_scenarios_verifications'

  belongs_to :scenario,     :class_name => 'Diagnostics::Scenario'
  belongs_to :verification, :class_name => 'Diagnostics::Verification'
  
  validates_presence_of :scenario_id, :verification_id, :rating
end

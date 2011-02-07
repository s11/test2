# == Schema Information
# Schema version: 20091007002944
#
# Table name: diagnostics_symptoms
#
#  id          :integer(4)      not null, primary key
#  system_id   :integer(4)      not null
#  description :string(255)     not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Diagnostics::Symptom < ActiveRecord::Base
  set_table_name 'diagnostics_symptoms'

  belongs_to :system,           :class_name => 'Diagnostics::System'
  
  has_many :scenarios_symptoms, :class_name => 'Diagnostics::ScenariosSymptom'
  has_many :scenarios,          :through => :scenarios_symptoms
  
  validates_presence_of :description
end

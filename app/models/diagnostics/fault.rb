# == Schema Information
# Schema version: 20091007002944
#
# Table name: diagnostics_faults
#
#  id          :integer(4)      not null, primary key
#  system_id   :integer(4)      not null
#  description :string(255)     not null
#  rating      :string(255)     not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Diagnostics::Fault < ActiveRecord::Base
  set_table_name 'diagnostics_faults'

  belongs_to :system,   :class_name => 'Diagnostics::System'
  belongs_to :symptoms, :class_name => 'Diagnostics::Symptom'
  
  validates_presence_of :description, :rating
end

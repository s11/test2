# == Schema Information
# Schema version: 20091007002944
#
# Table name: diagnostics_systems
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#

class Diagnostics::System < ActiveRecord::Base
  set_table_name 'diagnostics_systems'

  has_many :problems,         :class_name => 'Diagnostics::Problem',        :dependent => :delete_all
  has_many :faults,           :class_name => 'Diagnostics::Fault',          :dependent => :delete_all
  has_many :symptoms,         :class_name => 'Diagnostics::Symptom',        :dependent => :delete_all
  has_many :verifications,    :class_name => 'Diagnostics::Verification',   :dependent => :delete_all
  has_many :identifications,  :class_name => 'Diagnostics::Identification', :dependent => :delete_all
  has_many :rectifications,   :class_name => 'Diagnostics::Rectification',  :dependent => :delete_all
  has_many :scenarios,        :class_name => 'Diagnostics::Scenario'
  
  has_many :exams, :through => :scenarios
  
  validates_presence_of :name
  
  default_scope :order => 'id'
end

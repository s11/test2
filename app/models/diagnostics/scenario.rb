# == Schema Information
# Schema version: 20091007002944
#
# Table name: diagnostics_scenarios
#
#  id          :integer(4)      not null, primary key
#  system_id   :integer(4)      not null
#  problem_id  :integer(4)      not null
#  fault_id    :integer(4)      not null
#  name        :string(255)     not null
#  sc_revision :integer(4)      default(1), not null
#  created_at  :datetime
#  updated_at  :datetime
#  description :text
#  is_practice :boolean(1)      not null
#

class Diagnostics::Scenario < ActiveRecord::Base
  
  set_table_name 'diagnostics_scenarios'
  
  belongs_to :system,                   :class_name => 'Diagnostics::System'
  belongs_to :problem,                  :class_name => 'Diagnostics::Problem'
  belongs_to :fault,                    :class_name => 'Diagnostics::Fault'
  
  has_many :scenarios_symptoms,         :class_name => 'Diagnostics::ScenariosSymptom', :dependent => :delete_all
  has_many :symptoms,                   :through => :scenarios_symptoms
  
  has_many :scenarios_verifications,    :class_name => 'Diagnostics::ScenariosVerification',    :dependent => :delete_all
  has_many :scenarios_identifications,  :class_name => 'Diagnostics::ScenariosIdentification',  :dependent => :delete_all
  has_many :scenarios_rectifications,   :class_name => 'Diagnostics::ScenariosRectification',   :dependent => :delete_all
  has_many :hints,                      :class_name => 'Diagnostics::Hint',                     :dependent => :delete_all
  
  has_many :exams,                      :class_name => 'Diagnostics::Exam'
  
  has_many :verifications,    :through => :scenarios_verifications
  has_many :identifications,  :through => :scenarios_identifications
  has_many :rectifications,   :through => :scenarios_rectifications
  
  validates_presence_of :name, :system_id, :problem_id, :fault_id
  
  named_scope :practice,      :conditions => {:is_practice => true}
  named_scope :non_practice,  :conditions => {:is_practice => false}
  
  default_scope :order => 'name'
  
  def <=>(a)
    self.name.split(' ')[1].to_i <=> a.name.split(' ')[1].to_i
  end
  
end

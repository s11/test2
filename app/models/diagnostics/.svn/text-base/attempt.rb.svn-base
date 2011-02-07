# == Schema Information
# Schema version: 20091007002944
#
# Table name: diagnostics_attempts
#
#  id                :integer(4)      not null, primary key
#  exam_id           :integer(4)      not null
#  verification_id   :integer(4)
#  identification_id :integer(4)
#  rectification_id  :integer(4)
#  hint_id           :integer(4)
#  classification    :string(14)
#  marks_deducted    :integer(4)      default(0), not null
#  created_at        :datetime
#  updated_at        :datetime
#

# FIXME: Documentation would be nice
class Diagnostics::Attempt < ActiveRecord::Base
  set_table_name 'diagnostics_attempts'
  
  # Associations
  belongs_to :exam,           :class_name => 'Diagnostics::Exam'
  belongs_to :verification,   :class_name => 'Diagnostics::Verification'
  belongs_to :identification, :class_name => 'Diagnostics::Identification'
  belongs_to :rectification,  :class_name => 'Diagnostics::Rectification'
  
  # Validations
  validates_presence_of :exam_id
  validates_numericality_of :marks_deducted
  
  before_validation :set_marks_deducted
  after_create      :deduct_marks
  
  named_scope :verification, :conditions => ['classification = ?', 'verification']
  named_scope :identification, :conditions => ['classification = ?', 'identification']
  named_scope :rectification, :conditions => ['classification = ?', 'rectification']
  
  named_scope :successful, :conditions => ['marks_deducted = 0']
  
  def verify?
    self.classification.eql?('verification')
  end
  
  def identify?
    self.classification.eql?('identification')
  end
  
  def rectify?
    self.classification.eql?('rectification')
  end
  
  # Determines the correct result for the action chosen in this attempt.
  # If there's no specific result for the scenario lookup the default result.
  def result
    
    if not self.verification_id.nil?
      verification         = Diagnostics::Verification.find(self.verification_id)
      assoc_verification   = self.exam.scenario.scenarios_verifications.find_by_verification_id(self.verification_id) rescue nil
      message              = ((assoc_verification.nil? or assoc_verification.result.empty?) ? verification.result : assoc_verification.result)
      
    elsif not self.identification_id.nil?
      identification       = Diagnostics::Identification.find(self.identification_id)
      assoc_identification = self.exam.scenario.scenarios_identifications.find_by_identification_id(self.identification_id) rescue nil
      message              = ((assoc_identification.nil? or assoc_identification.result.empty?) ? identification.result : assoc_identification.result)
      
    elsif not self.rectification.nil?
      rectification        = Diagnostics::Rectification.find(self.rectification_id)
      assoc_rectification  = self.exam.scenario.scenarios_rectifications.find_by_rectification_id(self.rectification_id) rescue nil
      message              = ((assoc_rectification.nil? or assoc_rectification.result.empty?) ? rectification.result : assoc_rectification.result)
      
    end
    
    message
  end
  
  private

  def deduct_marks
    unless marks_deducted.nil? or marks_deducted.zero?
      exam.deduct_marks marks_deducted
      exam.save!
    end
  end
  
  def set_marks_deducted
    unless self.verification_id.nil? and self.identification.nil? and self.rectification_id.nil?
      
      if not self.verification.nil?
        test_action = self.exam.scenario.scenarios_verifications.find_by_verification_id(self.verification_id)
      elsif not self.identification.nil?
        test_action = self.exam.scenario.scenarios_identifications.find_by_identification_id(self.identification_id)
      elsif not self.rectification.nil?
        test_action = self.exam.scenario.scenarios_rectifications.find_by_rectification_id(self.rectification_id)
      end
      
      self.marks_deducted = (test_action.nil? ? 1 : test_action.rating - 1) # TODO: constant needs to be removed
    end
    
    unless self.hint_id.nil?
      hint                = self.exam.scenario.hints.find(self.hint_id)
      self.marks_deducted = hint.penalty
    end
  end
  
end

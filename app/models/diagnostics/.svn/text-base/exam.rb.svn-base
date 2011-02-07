# == Schema Information
# Schema version: 20091007002944
#
# Table name: diagnostics_exams
#
#  id              :integer(4)      not null, primary key
#  user_id         :integer(4)      not null
#  scenario_id     :integer(4)      not null
#  attempt_no      :integer(4)      not null
#  commenced_at    :datetime
#  completed_at    :datetime
#  created_at      :datetime
#  updated_at      :datetime
#  marks_remaining :integer(4)      default(10), not null
#  final_mark      :integer(4)
#  system_id       :integer(4)      not null
#  is_practice     :boolean(1)      not null
#

# FIXME: Documentation would be nice
class Diagnostics::Exam < ActiveRecord::Base
  set_table_name 'diagnostics_exams'
  
  # Constants
  MAX_TESTS = 10
  
  # Associations
  belongs_to :user
  belongs_to :scenario, :class_name => 'Diagnostics::Scenario'
  
  has_many :attempts,   :class_name => 'Diagnostics::Attempt',    :order => 'id'
  has_many :choices,    :class_name => 'Diagnostics::ExamChoice', :order => 'id'
  
  # Validations
  validates_presence_of :user_id, :scenario_id, :attempt_no
  validates_numericality_of :attempt_no
  
  before_validation :assign_attempt_no
  after_create      :assign_choice_selection



  # Scopes -------------------------------------------------------------------------------------------------------------------------
  named_scope :assessment,  :conditions => { :is_practice => false }
  named_scope :practice,    :conditions => { :is_practice => true }

  named_scope :by_scenario,   lambda { |scenario|       { :conditions => { :scenario_id => scenario }}}
  named_scope :by_system,     lambda { |system|         { :conditions => { :system_id   => system   }}}
  named_scope :between_dates, lambda { |start, finish|  { :conditions => ['commenced_at BETWEEN ? AND ?', start.to_datetime.beginning_of_day,  finish.to_datetime.end_of_day] }}
  

  
  # Additional Attributes
  attr_accessor :step
  
  def deduct_marks(num_marks)
    # Ensure we don't set a negative mark
    self.marks_remaining = ((self.marks_remaining - num_marks) < 0 ? 0 : (self.marks_remaining - num_marks))
    save!
  end
  
  def total_marks_deducted
    Attempt.sum('marks_deducted', :conditions => {:exam_id => self.id})
  end
  
  def show_hint?(classification)
    hint    = self.scenario.hints.find_by_classification(classification) rescue nil
    attempt = self.attempts.find_by_hint_id(hint.id) rescue nil
    
    attempt.nil? ? false : true
  end
  
  def show_hint_button?(classification)
    self.attempts.count(:conditions => ["#{classification}_id IS NOT NULL"]) > 1
  end
  
  def solved
    (not self.attempts.find_by_marks_deducted(0, :conditions => 'rectification_id IS NOT NULL').nil?)
  end
  
  def completed
    self.marks_remaining <= 0 or self.solved
  end
  
  private
  
  def assign_attempt_no
    max_attempt_no = Diagnostics::Exam.search.maximum('attempt_no', 
      :conditions => ['user_id = ? and scenario_id = ?', self.user_id, self.scenario_id]) || 0
    self.attempt_no = max_attempt_no + 1
  end
  
  def assign_choice_selection
    
    verification_ids  = self.scenario.scenarios_verifications.map(&:verification_id)
    selection_size    = (verification_ids.length > MAX_TESTS ? verification_ids.length : MAX_TESTS)
    verification_ids  = verification_ids.random_selection(selection_size)
    verification_ids.each{|vid| self.choices.create!({:choice_id      => vid,
                                                      :classification => 'verify'})}
    
    identification_ids  = self.scenario.scenarios_identifications.map(&:identification_id)
    selection_size      = (identification_ids.length > MAX_TESTS ? identification_ids.length : MAX_TESTS)
    identification_ids  = identification_ids.random_selection(selection_size)
    identification_ids.each{|iid| self.choices.create!({:choice_id      => iid, 
                                                        :classification => 'identify'})}
    
    rectification_ids = self.scenario.scenarios_rectifications.map(&:rectification_id)
    selection_size    = (rectification_ids.length > MAX_TESTS ? rectification_ids.length : MAX_TESTS)
    rectification_ids = rectification_ids.random_selection(selection_size)
    rectification_ids.each{|rid| self.choices.create!({ :choice_id      => rid,
                                                        :classification => 'rectify'})}
  end
  
end

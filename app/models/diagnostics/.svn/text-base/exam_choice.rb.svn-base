# == Schema Information
# Schema version: 20091007002944
#
# Table name: diagnostics_exam_choices
#
#  id             :integer(4)      not null, primary key
#  exam_id        :integer(4)      not null
#  classification :string(255)     not null
#  choice_id      :integer(4)      not null
#  created_at     :datetime
#  updated_at     :datetime
#

class Diagnostics::ExamChoice < ActiveRecord::Base
  
  set_table_name 'diagnostics_exam_choices'
  
  belongs_to :exam, :class_name => 'Diagnostics::Exam'
  
  named_scope :verification, :conditions => ['classification = ?', 'verify']
  named_scope :identification, :conditions => ['classification = ?', 'identify']
  named_scope :rectification, :conditions => ['classification = ?', 'rectify']
  
end

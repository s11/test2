# == Schema Information
# Schema version: 20091007002944
#
# Table name: terms_and_conditions_acceptances
#
#  id                      :integer(4)      not null, primary key
#  terms_and_conditions_id :integer(4)
#  created_at              :datetime
#  updated_at              :datetime
#  lock_version            :integer(4)      default(0), not null
#  user_id                 :integer(4)
#

# 
#  terms_and_conditions_acceptance.rb
#  report_rework
#  
#  Created by John Meredith on 2008-04-18.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class TermsAndConditionsAcceptance < ActiveRecord::Base
  # Attributes ---------------------------------------------------------------------------------------------------------------------
  attr_readonly :terms_and_conditions_id, :user_id



  # Associations -------------------------------------------------------------------------------------------------------------------
  belongs_to :user
  belongs_to :terms_and_conditions, :class_name => "TermsAndConditions", :foreign_key => "terms_and_conditions_id"



  # Validations --------------------------------------------------------------------------------------------------------------------
  validates_presence_of :terms_and_conditions_id, :user_id
  validates_associated  :terms_and_conditions, :user



  # Scopes -------------------------------------------------------------------------------------------------------------------------
  named_scope :by_terms_and_conditions, lambda { |tac|  { :conditions => ['terms_and_conditions_id = ?', tac] }}
end

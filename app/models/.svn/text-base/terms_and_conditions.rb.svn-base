# == Schema Information
# Schema version: 20091007002944
#
# Table name: terms_and_conditions
#
#  id               :integer(4)      not null, primary key
#  content          :text
#  effective_from   :datetime        not null
#  superseded_after :datetime
#  created_at       :datetime
#  updated_at       :datetime
#  lock_version     :integer(4)      default(0), not null
#  menu_id          :integer(4)
#

# 
#  terms_and_conditions.rb
#  report_rework
#  
#  Created by John Meredith on 2008-04-18.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class TermsAndConditions < ActiveRecord::Base
  # Associations -------------------------------------------------------------------------------------------------------------------
  belongs_to  :menu
  has_many    :acceptances,  :class_name => "TermsAndConditionsAcceptance", :foreign_key => "terms_and_conditions_id"
  
  
  
  # Validations --------------------------------------------------------------------------------------------------------------------
  validates_presence_of :content
  validates_presence_of :effective_from



  # Scopes -------------------------------------------------------------------------------------------------------------------------
  default_scope :conditions => "effective_from <= UTC_TIMESTAMP() AND (superseded_after > UTC_TIMESTAMP() OR superseded_after IS NULL)"
  named_scope   :latest_by_menu, lambda { |menu| { :conditions => [ "menu_id IS NULL OR menu_id=?", menu ], :order => "menu_id DESC", :limit => 1 }}


  
  # Return the latest terms and conditions given the provided menu
  def self.latest(menu)
    latest_by_menu(menu).first
  end
end

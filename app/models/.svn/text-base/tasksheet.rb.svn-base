# == Schema Information
# Schema version: 20091007002944
#
# Table name: tasksheets
#
#  id             :integer(4)      not null, primary key
#  number         :string(4)       not null
#  title          :text            default(""), not null
#  short_name     :text(255)       default(""), not null
#  created_at     :datetime
#  updated_at     :datetime
#  lock_version   :integer(4)      default(1)
#  search_content :text
#

# 
#  tasksheet.rb
#  report_rework
#  
#  Created by John Meredith on 2008-04-09.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class Tasksheet < ActiveRecord::Base
  # Attribute stuff ----------------------------------------------------------------------------------------------------------------
  attr_readonly :number, :title, :short_name
  alias_attribute :description, :title



  # Associations -------------------------------------------------------------------------------------------------------------------
  has_many :category_items, :as => :attachable
  has_many :tasksheet_submissions
  has_many :natef_task_areas



  # Validations --------------------------------------------------------------------------------------------------------------------
  validates_presence_of     :title, :short_name
  validates_presence_of     :number, :on => :create, :message => "can't be blank"
  validates_uniqueness_of   :number, :on => :create, :message => "must be unique"



  # Validations --------------------------------------------------------------------------------------------------------------------
  named_scope :name_search, lambda { |tag| { :conditions => ["number LIKE :tag OR title LIKE :tag OR short_name LIKE :tag", {:tag => "%#{tag}%"}] } }
  


  # The display name of a tasksheet includes it's number
  def name
    "#{number}: #{short_name}"
  end

  # Tasksheets are always 'assessments'
  def kind
    :activity
  end
end

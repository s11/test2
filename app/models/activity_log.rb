# == Schema Information
# Schema version: 20091007002944
#
# Table name: activity_logs
#
#  id               :integer(4)      not null, primary key
#  user_id          :integer(4)      not null
#  login_at         :datetime        not null
#  category_item_id :integer(4)      not null
#  element          :string(255)     not null
#  opened_at        :datetime        not null
#  closed_at        :datetime
#

#--
#  activity_log.rb
#  management
#  
#  Created by John Meredith on 2009-08-06.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class ActivityLog < ActiveRecord::Base
  ELEMENT_TYPES = ['html', 'video', 'knowledge check', 'dvom', 'workshop activity', 'assessment checklist', 'handout activity', 'tasksheet']


  # Behaviours ---------------------------------------------------------------------------------------------------------------------
  acts_as_reportable
  
  
  
  # Associations -------------------------------------------------------------------------------------------------------------------
  belongs_to  :user
  belongs_to  :category_item
  has_one     :client, :through => :user



  # Validations --------------------------------------------------------------------------------------------------------------------
  validates_presence_of   :user_id, :login_at, :category_item_id, :element, :opened_at
  validates_associated    :user, :category_item
  validates_uniqueness_of :user_id, :scope => [:login_at, :category_item_id, :element, :opened_at]
  validates_inclusion_of  :element, :in => ELEMENT_TYPES



  # Scopes -------------------------------------------------------------------------------------------------------------------------

  # Dated scopes
  named_scope :before_date,   lambda { |date|           { :conditions => ['opened_at < ?', date.to_datetime.beginning_of_day] }}
  named_scope :up_to_date,    lambda { |date|           { :conditions => ['opened_at <= ?', date.to_datetime.end_of_day] }}
  named_scope :between_dates, lambda { |start, finish|  { :conditions => ['opened_at BETWEEN ? AND ?', start.to_datetime.beginning_of_day.utc,  finish.to_datetime.end_of_day.utc] }}
  named_scope :between_times, lambda { |start, finish|  { :conditions => ['opened_at BETWEEN ? AND ?', start.to_datetime.utc,  finish.to_datetime.utc] }}
  named_scope :on_date,       lambda { |date|           { :conditions => ['opened_at BETWEEN ? AND ?', date.to_datetime.beginning_of_day.utc, date.to_datetime.end_of_day.utc] }}
  named_scope :in_last,       lambda { |period|         { :conditions => ['opened_at >= ?',  period.ago.to_datetime.utc] }}
  named_scope :since,         lambda { |date|           { :conditions => ['opened_at >= ?',  date.to_datetime.utc] }}
  named_scope :after_date,    lambda { |date|           { :conditions => ['opened_at > ?',   date.to_datetime.utc] }}
  named_scope :yesterday,     :conditions => [ "opened_at BETWEEN ? AND ?", Time.now.yesterday,  Time.now.in_time_zone.end_of_day.utc ]
  named_scope :today,         :conditions => [ "opened_at BETWEEN ? AND ?", Time.now.yesterday,  Time.now.in_time_zone.end_of_day.utc  ]


  # Field scopes
  named_scope :by_user,           lambda { |value| { :conditions => { :user_id          => value }}}
  named_scope :by_category_item,  lambda { |value| { :conditions => { :category_item_id => value }}}
  named_scope :by_topic_element,  lambda { |value| { :conditions => { :element          => value }}}


  # Topic Elements
  named_scope :by_element_type, lambda { |type| { :conditions => { :element => type }}}
  named_scope :html,                  :conditions => { :element => 'html'                 }
  named_scope :videos,                :conditions => { :element => 'video'                }
  named_scope :knowledge_checks,      :conditions => { :element => 'knowledge check'      }
  named_scope :dvoms,                 :conditions => { :element => 'dvom'                 }
  named_scope :workshop_activities,   :conditions => { :element => 'workshop activity'    }
  named_scope :assessment_checklists, :conditions => { :element => 'assessment checklist' }
  named_scope :handout_activities,    :conditions => { :element => 'handout activity'     }
  named_scope :tasksheets,            :conditions => { :element => 'tasksheet'            }
end

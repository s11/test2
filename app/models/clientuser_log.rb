# 
#  clientuser_log.rb
#  online
#  
#  Created by John Meredith on 2008-03-09.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class ClientuserLog < ActiveRecord::Base
  set_table_name("clientuser_log")

  # Associations
  belongs_to :client, :foreign_key => "client_prefix"
  belongs_to :user,   :foreign_key => [:client_prefix, :username]
  belongs_to :menu,   :class_name => "Content::Menu", :foreign_key => "menu_id"


  def user_with_set_table_name
    User.set_table_name(client.client_table)
    user_without_set_table_name
  end
  alias_method_chain :user, :set_table_name


  # Dated scopes
  named_scope :before_date,   lambda { |date|           { :conditions => ['start < ?', date.to_datetime.to_f] }}
  named_scope :between_dates, lambda { |start, finish|  { :conditions => ['start BETWEEN ? AND ?', start.to_datetime.beginning_of_day.to_f, finish.to_datetime.end_of_day.to_f] }}
  named_scope :on_date,       lambda { |date|           { :conditions => ['start BETWEEN ? AND ?', date.to_datetime.beginning_of_day.to_f, date.to_datetime.end_of_day.to_f] }}
  named_scope :in_last,       lambda { |period|         { :conditions => ['start >= ?',  period.ago.to_datetime.to_f] }}
  named_scope :since,         lambda { |date|           { :conditions => ['start >= ?',  date.to_datetime.to_f] }}
  named_scope :after_date,    lambda { |date|           { :conditions => ['start > ?',   date.to_datetime.to_f] }}
  named_scope :yesterday,     :conditions => [ "start BETWEEN ? AND ?", Date.yesterday.beginning_of_day.to_f, Date.yesterday.end_of_day.to_f ]

  # Field scopes
  named_scope :by_username,       lambda { |username| { :conditions => { :username         => username      }}}
  named_scope :by_menu_id,        lambda { |menu_id|  { :conditions => { :menu_id          => menu_id       }}}
  named_scope :by_menu,           lambda { |menu|     { :conditions => { :menu_id          => menu.menu_id  }}}
  named_scope :by_version,        lambda { |version|  { :conditions => { :version          => version       }}}
  named_scope :by_client_prefix,  lambda { |prefixes| { :conditions => { :client_prefix    => prefixes      }}}
  named_scope :by_topic_element,  lambda { |value|    { :conditions => { :topic_element    => value         }}}
  named_scope :by_topic_id,       lambda { |topic_id| { :conditions => { :publish_topic_id => topic_id      }}}

  named_scope :pages,                 :conditions => "topic_element != 'logon'"
  named_scope :sessions,              :conditions => "topic_element = 'logon'"
  named_scope :searches,              :conditions => "topic_element = 'search'"
  named_scope :topics,                :conditions => "topic_element NOT IN ('logon', 'search')"

  # Topic Elements
  named_scope :videos,                :conditions => "topic_element = 'video'"
  named_scope :knowledge_checks,      :conditions => "topic_element = 'knowledge check'"
  named_scope :dvoms,                 :conditions => "topic_element = 'dvom'"
  named_scope :workshop_activities,   :conditions => "topic_element = 'workshop activity'"
  named_scope :assessment_checklists, :conditions => "topic_element = 'assessment checklist'"
  named_scope :handout_activities,    :conditions => "topic_element = 'handout activity'"
  named_scope :tasksheets,            :conditions => "topic_element = 'tasksheet'"
end

# 
#  message_recipient.rb
#  online_trunk
#  
#  Created by John Meredith on 2008-04-01.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class Old::MessageRecipient < ActiveRecord::Base
  # Table name can't be inferred
  set_table_name "deprecated_message_recipients"


  # Associations
  belongs_to :user
  belongs_to :message, :class_name => "Old::Message", :foreign_key => "message_id"


  # Validations
  # validates_presence_of :client_prefix, :username, :message_id
  # validates_associated  :user, :message


  named_scope :pending,     :conditions => { :state => 'pending' }
  named_scope :viewed,      :conditions => { :state => 'viewed' }
  named_scope :not_trashed, :conditions => { :state => ['pending', 'viewed'] }
  named_scope :trashed,     :conditions => { :state => 'trashed' }
  named_scope :not_wiped,   :conditions => { :state => ['pending', 'viewed', 'trashed'] }
  named_scope :wiped,       :conditions => { :state => 'wiped' }
  named_scope :by_state,    lambda { |state| { :conditions => { :state => state }}}

  named_scope :by_user, lambda {|user| { :conditions => { :client_prefix => user.client_prefix, :username => user.username }}}


  attr_protected :user, :recipients


  # Acts as State Machine stuff
  acts_as_state_machine :initial => :pending

  state :pending
  state :viewed
  state :trashed
  state :wiped

  event :view do
    transitions :to => :viewed, :from => :pending
  end

  event :trash do
    transitions :to => :trashed, :from => [:viewed, :pending]
  end

  event :wipe do
    transitions :to => :wiped, :from => :trashed
  end
end

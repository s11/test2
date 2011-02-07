# 
#  message.rb
#  online_trunk
#  
#  Created by John Meredith on 2008-04-01.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class Old::Message < ActiveRecord::Base
  # Table name can't be inferred
  set_table_name "deprecated_messages"

  
  # Behaviours ---------------------------------------------------------------------------------------------------------------------
  acts_as_state_machine :initial => :draft



  # Attributes ---------------------------------------------------------------------------------------------------------------------
  attr_protected :user, :recipients



  # Associations -------------------------------------------------------------------------------------------------------------------
  belongs_to  :user
  has_many    :recipients,  :class_name => "Old::MessageRecipient",  :foreign_key => "message_id", :conditions => "state != 'deleted'"
  has_many    :replies,     :class_name => "Old::Message",           :foreign_key => "parent_id",  :order => "created_at ASC"



  # Validations --------------------------------------------------------------------------------------------------------------------
  validates_presence_of :subject, :body
  validates_associated  :user, :recipients



  # Scopes -------------------------------------------------------------------------------------------------------------------------
  named_scope :drafts,      :conditions => { :state => 'draft' }
  named_scope :dispatched,  :conditions => { :state => 'dispatched' }
  named_scope :not_trashed, :conditions => { :state => ['draft', 'dispatched'] }
  named_scope :trashed,     :conditions => { :state => 'trashed' }
  named_scope :not_wiped,   :conditions => { :state => ['draft', 'dispatched', 'trashed'] }
  named_scope :wiped,       :conditions => { :state => 'wiped' }
  named_scope :by_state,    lambda { |state| { :conditions => { :state => state }}}



  # Acts as State Machine stuff ----------------------------------------------------------------------------------------------------
  state :draft
  state :dispatched
  state :trashed
  state :wiped

  event :draft do
    transitions :to => :draft, :from => [:draft]
  end

  event :dispatch do
    transitions :to => :dispatched, :from => :draft
  end

  event :trash do
    transitions :to => :trashed, :from => [:draft, :dispatched]
  end

  event :wipe do
    transitions :to => :wiped, :from => :trashed
  end

  def can_be_replied_to?(current_user)
    # Check if the sender still exists
    return false if self.user.blank?

    # Check if this user sent the message
    return false if self.username.eql?(current_user.username)

    # Check if this user has trashed this message
    return false if self.user.eql?(current_user) and self.state.eql?('trashed')
    return false if self.recipients.find_by_client_prefix_and_username(current_user.client_prefix, current_user.username).andand.state.eql?('trashed')

    true
  end

end

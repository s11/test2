# == Schema Information
# Schema version: 20091007002944
#
# Table name: access_packs
#
#  id           :integer(8)      not null, primary key
#  regcode      :string(19)      default(""), not null
#  expiry       :datetime
#  ship_date    :string(2)
#  activated_on :datetime
#  previous_id  :integer(8)
#  invoice      :string(10)
#  user_id      :integer(4)
#  client_id    :integer(4)
#

# 
#  access_pack.rb
#  online
#  
#  Created by John Meredith on 2009-02-04.
#  Copyright 2009 CDX Global. All rights reserved.
# 
class AccessPack < ActiveRecord::Base
  # Attributes
  attr_readonly :client_id, :invoice

  
  # Associations
  belongs_to :client
  belongs_to :user

  
  # Validation
  validates_presence_of :invoice,   :if => Proc.new{ |reg| not reg.client_id.nil? }
  validates_presence_of :client_id, :if => Proc.new{ |reg| not reg.invoice.nil? }

  
  # Scopes
  named_scope :current,     :conditions => "expiry > UTC_TIMESTAMP"
  named_scope :expired,     :conditions => "expiry <= UTC_TIMESTAMP"

  scope_procedure :activated,   lambda  { activated_on_not_null }
  scope_procedure :unactivated, lambda  { activated_on_null     }
  scope_procedure :assigned,    lambda  { client_id_not_null    }
  scope_procedure :unassigned,  lambda  { client_id_null        }


  class << self
    # Returns true if the all of the IDs between the given range of start_id and finish_id have not yet been assigned. False
    # otherwise
    def block_free?(start_id, finish_id)
      AccessPack.count(:id, :conditions => { :client_id => nil, :id => (start_id..finish_id) }) == (start_id..finish_id).count
    end
  end
end

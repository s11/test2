# == Schema Information
# Schema version: 20091007002944
#
# Table name: netsuite_trial_requests
#
#  id          :integer(4)      not null, primary key
#  netsuite_id :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

# 
#  net_suite_trial_request.rb
#  online
#  
#  Created by John Meredith on 2009-01-28.
#  Copyright 2009 CDX Global. All rights reserved.
# 
class NetsuiteTrialRequest < ActiveRecord::Base
  # Validations
  validates_uniqueness_of :netsuite_id
  validates_presence_of   :netsuite_id
end

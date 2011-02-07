# == Schema Information
# Schema version: 20091007002944
#
# Table name: timeline_events
#
#  id                     :integer(4)      not null, primary key
#  event_type             :string(255)
#  subject_type           :string(255)
#  actor_type             :string(255)
#  secondary_subject_type :string(255)
#  subject_id             :integer(4)
#  actor_id               :integer(4)
#  secondary_subject_id   :integer(4)
#  created_at             :datetime
#  updated_at             :datetime
#

# 
#  timeline_event.rb
#  online
#  
#  Created by John Meredith on 2009-02-24.
#  Copyright 2009 CDX Global. All rights reserved.
# 
class TimelineEvent < ActiveRecord::Base
  belongs_to :actor,              :polymorphic => true
  belongs_to :subject,            :polymorphic => true
  belongs_to :secondary_subject,  :polymorphic => true
end

#--
#  daily_activity_log.rb
#  management
#  
#  Created by John Meredith on 2009-11-22.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class DailyActivityLog < ActiveRecord::Base
  set_table_name :activity_logs_daily


  # Associations -------------------------------------------------------------------------------------------------------------------
  belongs_to :category_item
  belongs_to :client
  belongs_to :user

  
  # Validations --------------------------------------------------------------------------------------------------------------------
  validates_presence_of   :category_item_id, :client_id, :user_id, :log_date
  validates_uniqueness_of :user_id, :scope => [ :log_date, :category_item_id ]
  validates_associated    :category_item, :client, :user
end

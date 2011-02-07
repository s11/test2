# == Schema Information
# Schema version: 20091007002944
#
# Table name: csv_files
#
#  id               :integer(4)      not null, primary key
#  client_id        :integer(4)
#  csv_file_name    :string(255)
#  csv_content_type :string(255)
#  csv_file_size    :integer(4)
#  created_at       :datetime
#  updated_at       :datetime
#

# 
#  csv_file.rb
#  online
#  
#  Created by John Meredith on 2008-03-23.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class CsvFile < ActiveRecord::Base
  # Bahaviours ---------------------------------------------------------------------------------------------------------------------
  has_attached_file :csv



  # Associations -------------------------------------------------------------------------------------------------------------------
  belongs_to :client



  # Validations --------------------------------------------------------------------------------------------------------------------
  validates_presence_of :client_id
  validates_associated  :client
  # validates_attachment_content_type :csv, :content_type => ['text/csv']
end

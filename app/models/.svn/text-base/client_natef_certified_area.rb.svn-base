# == Schema Information
# Schema version: 20091007002944
#
# Table name: client_natef_certified_areas
#
#  id          :integer(4)      not null, primary key
#  version     :string(4)       default(""), not null
#  description :string(128)     default(""), not null
#  client_id   :integer(4)
#

# 
#  natef_client.rb
#  report_rework
#  
#  Created by John Meredith on 2008-04-09.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class ClientNatefCertifiedArea < ActiveRecord::Base
  VALID_NATEF_VERSIONS  = %w{ 2002 2005 2008 }
  DEFAULT_NATEF_VERSION = '2008'


  # Attributes ---------------------------------------------------------------------------------------------------------------------
  alias_attribute :name, :description


  # Associations -------------------------------------------------------------------------------------------------------------------
  belongs_to :client
  has_many :natef_task_areas, :finder_sql => 'SELECT * FROM natef_task_areas WHERE version=\'#{version}\' AND description=\'#{description}\''



  # Validations --------------------------------------------------------------------------------------------------------------------
  validates_presence_of   :client_id, :version, :description
  validates_inclusion_of  :version, :in => VALID_NATEF_VERSIONS
  validates_uniqueness_of :version, :scope => [:description, :client_id]
  validates_associated    :client



  # Scopes -------------------------------------------------------------------------------------------------------------------------
  named_scope :by_version,      lambda { |version|      { :conditions => { :version     => version      }}}
  named_scope :by_description,  lambda { |description|  { :conditions => { :description => description  }}}
  
  
  
end

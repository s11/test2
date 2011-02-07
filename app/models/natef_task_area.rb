# == Schema Information
# Schema version: 20091007002944
#
# Table name: natef_task_areas
#
#  id                     :integer(4)      not null, primary key
#  version                :string(4)       not null
#  title                  :text            default(""), not null
#  natef_reference        :string(255)
#  natef_priority         :string(255)
#  description            :string(128)     not null
#  section_description    :string(128)     not null
#  subsection             :text
#  subsection_description :string(128)
#  tasksheet_id           :integer(4)      not null
#

# 
#  natef_certification.rb
#  report_rework
#  
#  Created by John Meredith on 2008-04-09.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class NatefTaskArea < ActiveRecord::Base
  # Attributes ---------------------------------------------------------------------------------------------------------------------
  attr_readonly :version, :tasksheet_id, :natef_reference



  # Associations -------------------------------------------------------------------------------------------------------------------
  belongs_to :tasksheet



  # Validations --------------------------------------------------------------------------------------------------------------------
  validates_presence_of   :title, :natef_priority, :description, :section_description, :tasksheet_id

  with_options :on => :create do |on_create|
    on_create.validates_associated  :tasksheet
    on_create.validates_presence_of :version, :tasksheet_number, :natef_reference
  end

  with_options :scope => :version do |scope|
    scope.validates_uniqueness_of :tasksheet_number
  end

  

  # Scopes -------------------------------------------------------------------------------------------------------------------------
  named_scope :P1, :conditions => { :natef_priority => 'P1' }
  named_scope :P2, :conditions => { :natef_priority => 'P2' }
  named_scope :P3, :conditions => { :natef_priority => 'P3' }

  named_scope :by_ase_area,         lambda { |letter|           { :conditions => { :natef_reference_starts_with => letter           }}}
  named_scope :by_description,      lambda { |description|      { :conditions => { :description                 => description      }}}
  named_scope :by_natef_priority,   lambda { |priority|         { :conditions => { :natef_priority              => priority         }}}
  named_scope :by_natef_reference,  lambda { |natef_reference|  { :conditions => { :natef_reference             => natef_reference  }}}
  named_scope :by_section,          lambda { |letter|           { :conditions => { :natef_reference_contains    => letter           }}}
  named_scope :by_tasksheet,        lambda { |tasksheet|        { :conditions => { :tasksheet_id                => tasksheet        }}}
  named_scope :by_version,          lambda { |version|          { :conditions => { :version                     => version          }}}



  def self.names_by_version(version)
    all(:select => "description", :conditions => { :version => version }, :group => "description").map(&:description)
  end
end

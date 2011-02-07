# == Schema Information
# Schema version: 20091007002944
#
# Table name: topics
#
#  id                                :integer(4)      not null, primary key
#  kind                              :string(255)     not null
#  name                              :string(255)     not null
#  description                       :string(512)     default(""), not null
#  has_video                         :boolean(1)      not null
#  page_filename                     :string(255)
#  knowledge_check_filename          :string(255)
#  workshop_procedure_guide_filename :string(255)
#  assessment_checklist_filename     :string(255)
#  created_at                        :datetime
#  updated_at                        :datetime
#  deleted_at                        :datetime
#  lock_version                      :integer(4)      default(1), not null
#  search_content                    :text
#  summary                           :string(512)
#

#--
#  topic.rb
#  management
#  
#  Created by John Meredith on 2009-05-18.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class Topic < ActiveRecord::Base
  VIDEO_SIZES = {
    :lan    => 1,
    :cable  => 2,
    :dialup => 3
  }


  # Associations -------------------------------------------------------------------------------------------------------------------
  has_many :category_items, :as => :attachable



  # Validations --------------------------------------------------------------------------------------------------------------------
  validates_presence_of :name, :description



  # Wrap kin in StringInquirer. Allows Topic.kind.procedure?
  def kind
    ActiveSupport::StringInquirer.new(read_attribute(:kind))
  end

  # The filename of the video file to load
  def video_name
    page_filename.gsub(/(_2)?\.html/, '')
  end

  # Flash videos names depend on kind
  def flash_video_name
    return kind.procedure? ? "#{video_name}_p" : video_name
  end

  # Returns true if this topic has a Knowledge Check component
  def has_knowledge_check?
    knowledge_check_filename.present?
  end
  
  # Returns true if this topic has a workshop procedure guide
  def has_workshop_procedure_guide?
    workshop_procedure_guide_filename.present?
  end
end

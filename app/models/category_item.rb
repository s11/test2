# == Schema Information
# Schema version: 20091007002944
#
# Table name: categories_items
#
#  id                              :integer(4)      not null, primary key
#  category_id                     :integer(4)
#  item_id                         :integer(4)
#  item_type                       :string(255)
#  position                        :integer(4)      default(1), not null
#  legacy_publish_topic_id         :integer(4)
#  created_at                      :datetime
#  updated_at                      :datetime
#  deleted_at                      :datetime
#  lock_version                    :integer(4)      default(1), not null
#  dvom_filename                   :string(255)
#  handout_activity_sheet_filename :string(255)
#

#--
#  category_topic.rb
#  management
#  
#  Created by John Meredith on 2009-05-20.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class CategoryItem < ActiveRecord::Base
  # Rails can't figure out that this is an association table. Manually tell it where to look for records.
  set_table_name :categories_items



  # Behaviours ---------------------------------------------------------------------------------------------------------------------
  sortable :scope => :category_id
  acts_as_reportable



  # Associations -------------------------------------------------------------------------------------------------------------------
  belongs_to  :category
  belongs_to  :item, :polymorphic => true
  has_one     :menu_version, :through => :category

  has_many  :activity_logs
  has_many  :daily_activity_logs


  # Validations --------------------------------------------------------------------------------------------------------------------
  validates_uniqueness_of :category_id, :scope => [:item_id, :item_type, :dvom_filename, :handout_activity_sheet_filename]
  validates_presence_of   :category_id, :item_id, :item_type



  # Scopes -------------------------------------------------------------------------------------------------------------------------
  default_scope :conditions => "#{table_name}.deleted_at IS NULL OR #{table_name}.deleted_at > UTC_TIMESTAMP()"
  named_scope :tasksheets,  :conditions => { :item_type => Tasksheet.class_name }
  named_scope :topics,      :conditions => { :item_type => Topic.class_name     }



  # ThinkingSphinx -----------------------------------------------------------------------------------------------------------------
  define_index do
    # Topic fields
    indexes item(:name),            :as => :topic_name
    indexes item(:description),     :as => :topic_description

    indexes item(:number),          :as => :tasksheet_number
    indexes item(:title),           :as => :tasksheet_title
    indexes item(:short_name),      :as => :tasksheet_short_name

    indexes item(:search_content),  :as => :item_search_content

    has :category_id, :item_id, :item_type, :created_at
    has category(:menu_version_id), :as => :category_menu_version_id
  end


  # Returns true if this topic has a DVOM component
  def has_dvom?
    dvom_filename.present?
  end
  
  # Returns true if this topic has a handout activity sheet
  def has_handout_activity_sheet?
    handout_activity_sheet_filename.present?
  end


  # Returns the previous category item in the context of the menu version
  def previous_item
    @previous_category_item ||= CategoryItem.last(:joins => :category, :conditions => ["categories.menu_version_id=? AND categories_items.id < ?", menu_version.id, id])
  end

  # Returns the next category item in the context of the menu version
  def next_item
    @next_category_item ||= CategoryItem.first(:joins => :category, :conditions => ["categories.menu_version_id=? AND categories_items.id > ?", menu_version.id, id])
  end


  # Mark the model deleted_at as now.
  def destroy_without_callbacks
    self.class.update_all("deleted_at=UTC_TIMESTAMP()", "id = #{self.id}")
    self
  end

  # Override the default destroy to allow us to flag deleted_at.
  # This preserves the before_destroy and after_destroy callbacks.
  # Because this is also called internally by Model.destroy_all and
  # the Model.destroy(id), we don't need to specify those methods
  # separately.
  def destroy
    return false if callback(:before_destroy) == false
    result = destroy_without_callbacks
    callback(:after_destroy)
    self
  end
end

# == Schema Information
# Schema version: 20091007002944
#
# Table name: categories
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)     not null
#  kind            :string(255)     default("procedure"), not null
#  menu_version_id :integer(4)      not null
#  items_count     :integer(4)      default(0), not null
#  parent_id       :integer(4)
#  lft             :integer(4)
#  rgt             :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#  deleted_at      :datetime
#  lock_version    :integer(4)      default(1), not null
#  image_filename  :string(255)
#

#--
#  category.rb
#  management
#  
#  Created by John Meredith on 2009-05-18.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class Category < ActiveRecord::Base
  # The kind of category
  KINDS = %w{ procedure theory activity assessment information }


  # Behaviours ---------------------------------------------------------------------------------------------------------------------
  acts_as_nested_set :scope => :menu_version_id



  # Associations -------------------------------------------------------------------------------------------------------------------
  belongs_to :menu_version
  has_many_polymorphs :items, :from => [:tasksheets, :topics], :through => :category_items, :order => "categories_items.category_id, categories_items.position"



  # Validations --------------------------------------------------------------------------------------------------------------------
  validates_presence_of   :name, :kind
  validates_inclusion_of  :kind, :in => KINDS



  # Callbacks ----------------------------------------------------------------------------------------------------------------------
  before_destroy { |record| CategoryItem.destroy_all("category_id=#{record.id}") }



  # Scopes -------------------------------------------------------------------------------------------------------------------------
  default_scope :conditions => "#{table_name}.deleted_at IS NULL OR #{table_name}.deleted_at > UTC_TIMESTAMP()"
  


  # ThinkingSphinx -----------------------------------------------------------------------------------------------------------------
  define_index do
    indexes :name
    
    has :menu_version_id
  end


  def self_and_descendant_ids
    @self_and_descendant_ids ||= self_and_descendants.all(:select => "id").map(&:id)
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

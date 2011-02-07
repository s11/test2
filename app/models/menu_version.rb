# == Schema Information
# Schema version: 20091007002944
#
# Table name: menu_versions
#
#  id                        :integer(4)      not null, primary key
#  version                   :integer(4)      not null
#  moodle_course_category_id :integer(4)
#  menu_id                   :integer(4)      not null
#  created_at                :datetime
#  updated_at                :datetime
#  deleted_at                :datetime
#  lock_version              :integer(4)      default(1), not null
#  has_heirarchical_root     :boolean(1)
#  has_diagnostics           :boolean(1)      default(TRUE), not null
#  has_print_support         :boolean(1)      default(TRUE)
#

#--
#  version.rb
#  management
#  
#  Created by John Meredith on 2009-05-18.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class MenuVersion < ActiveRecord::Base
  # Behaviours ---------------------------------------------------------------------------------------------------------------------
  acts_as_reportable :only => [:version, :moodle_course_category_id]



  # Attributes -------------------------------------------------------------------------------------------------------------------
  attr_readonly :menu_id, :version



  # Associations -------------------------------------------------------------------------------------------------------------------
  belongs_to  :menu
  belongs_to  :moodle_course_category, :class_name => "Moodle::CourseCategory"

  has_many  :categories
  has_many  :category_items, :through => :categories
  has_many  :assessment_views
  has_many  :clients
  has_many  :users


  
  # Validations --------------------------------------------------------------------------------------------------------------------
  validates_presence_of     :version, :menu_id
  validates_numericality_of :version
  validates_associated      :menu, :moodle_course_category
  validates_uniqueness_of   :menu_id, :scope => [:version, :deleted_at]



  # Callbacks ----------------------------------------------------------------------------------------------------------------------
  before_destroy { |record| Category.destroy_all("menu_version_id=#{record.id}")}



  # Scopes -------------------------------------------------------------------------------------------------------------------------
  default_scope :conditions => "#{table_name}.deleted_at IS NULL OR #{table_name}.deleted_at > UTC_TIMESTAMP()", :order => "#{table_name}.version DESC"
  named_scope :by_version_number, lambda { |number|   { :conditions => { :version => number }}}
  named_scope :version_ge,        lambda { |version|  { :conditions => [ 'version >= ?', version ]}}
  


  # Override display in string context
  def to_s
    "%s [v%0.1f]" % [menu.name, (version.to_i / 10.0)]
  end


  # Returns true if the menu has a later version
  def has_later_version?
    menu.versions.exists?(['version > ?', version])
  end

  # Delegate method. Returns true if the menu is considered part of NATEF
  def has_natef_selection?
    @has_natef_selection ||= menu.has_natef_selection?
  end

  # Convenience method to get the root categories for the 
  def root_categories
    categories.roots
  end

  # Returns a random category_item. Currently limited to topics that have summaries.
  #
  # NOTE: We're only including Topics at this stage. Could conceivably include tasksheets etc at a later date
  def random_category_item
    category_items.topics.first(:offset => ActiveSupport::SecureRandom.random_number(category_items.topics.count))
  end



  # Moodle -------------------------------------------------------------------------------------------------------------------------
  # Return the Topic Group Test assessment view
  def topic_group_tests
    assessment_views.topic_group_tests.first
  end

  # Return the FTMW assessment view
  def find_the_missing_word_quizzes
    assessment_views.find_the_missing_word_quizzes.first
  end
  
  # Return the "Practice Exam" assessment view
  def practice_exams
    assessment_views.practice_exams.first
  end

  # Return the "Final Exam" assessment view
  def final_exams
    assessment_views.final_exams.first
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

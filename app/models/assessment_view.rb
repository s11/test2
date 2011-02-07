# == Schema Information
# Schema version: 20091007002944
#
# Table name: assessment_views
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)
#  moodle_quiz_id  :integer(4)
#  parent_id       :integer(4)
#  lft             :integer(4)
#  rgt             :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#  sortorder       :integer(4)
#  menu_version_id :integer(4)
#

# 
#  assessment_view.rb
#  report_rework
#  
#  Created by John Meredith on 2008-04-13.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class AssessmentView < ActiveRecord::Base
  # Behaviours -------------------------------------------------------------------------------------------------------------------
  VALID_ASSESSMENT_TYPES = [
    "Final Exams",
    "Practice Exams",
    "Find-the-Missing Word Quizzes",
    "Topic Group Tests"
  ]


  # Behaviours -------------------------------------------------------------------------------------------------------------------
  acts_as_nested_set :scope => :menu_version


  # Associations -------------------------------------------------------------------------------------------------------------------
  belongs_to :menu_version, :class_name => "MenuVersion"
  belongs_to :moodle_quiz,  :class_name => "Moodle::Quiz", :foreign_key => "moodle_quiz_id"



  # Scopes -------------------------------------------------------------------------------------------------------------------------
  # Usually to be used with by_menu and/or by_version below.
  named_scope :topic_group_tests,             :conditions => { :name => 'Topic Group Tests'             }
  named_scope :find_the_missing_word_quizzes, :conditions => { :name => 'Find-the-Missing Word Quizzes' }
  named_scope :practice_exams,                :conditions => { :name => 'Practice Exams'                }
  named_scope :final_exams,                   :conditions => { :name => 'Final Exams'                   }



  # Returns all of the quizzes found under the given category
  def quiz_ids
    self_and_descendants.map(&:moodle_quiz_id).compact
  end


  # The following class method scours the moodle_master databases and builds
  # an easily queried tree.
  #
  # Create a nested tree structure similar to:
  #
  # |- Topic Group Tests                (assessment_type)
  #   |- Safety & Information           (assessment_group)
  #     |- Hazards & emergencies
  #     |- Personal & property safety
  #     ...
  # |- Find-the-Missing Word Quizzes
  #   |- Safety & Information
  #     |- Hazards & emergencies
  #     |- Personal & property safety
  #     ...
  #
  # Usage: "AssessmentView.rebuild_quiz_map" in the Rails console
  #
  # FIXME: This class method is not very DRY. Should possibly be cleaned up when hell freezes over ;-)
  def self.rebuild_quiz_map
    
    # Make sure the table is empty and the auto-increment counter reset
    AssessmentView.connection.execute("TRUNCATE assessment_views")
    
    # Default master table
    Moodle::Base.setup_tables_by_database('moodle_master2')
    
    AssessmentView.transaction do
      
      # ========================================================================
      # Version 51: ARK, ASE, IMI, AUR, GS, NZ, ASE 2 Core, Alberta
      # ------------------------------------------------------------------------
      [1, 3, 4, 5, 9, 17, 19].each do |menu_id|
        menu = Menu.find(menu_id)
        AssessmentView.build_standardised_51_view(menu)
      end
      
      
      # ========================================================================
      # Version 51: RS, ASE 4 Core
      # ------------------------------------------------------------------------
      [2, 6, 15].each do |menu_id|
        menu = Menu.find(menu_id)
        AssessmentView.build_standardised_51_view_with_parts(menu)
      end
      
      
      # ========================================================================
      # CDX ARK
      # ------------------------------------------------------------------------
      menu = Menu.find(1)
      
      # Version 41
      menu_version  = menu.versions.find_by_version(41)
      root          = AssessmentView.create_or_find(menu_version, menu.name)
      Moodle::Course.find_all_by_category(menu_version.moodle_course_category_id, :order => 'sortorder').each do |course|
        case course.fullname
          when /Activity Quizzes/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Find-the-Missing Word Quizzes', root)
            
            assessment_group_name = course.fullname.gsub(/\s+Activity Quizzes$/, '')
            assessment_group_name.gsub!(/^CDX ARK\+\s+/, '')
            assessment_group = AssessmentView.create_or_find(menu_version, assessment_group_name, assessment_type)
            assessment_group.sortorder = course.sortorder
            assessment_group.save
      
            course.quizzes.each do |quiz|
              quiz.name.gsub!(/\s+(Practice ([tT]est|Exam)|Final Exam|topic group test( topic group test)?|find-the-missing word|Acti?vir?ty Quiz)$/, '')
              AssessmentView.create(:menu_version_id => menu_version.id, :name => quiz.name, :moodle_quiz_id => quiz.id).move_to_child_of(assessment_group)
            end
        
          when /Practice Tests & Final Exams/
            practice_exams = AssessmentView.create_or_find(menu_version, 'Practice Exams', root)
            final_exams    = AssessmentView.create_or_find(menu_version, 'Final Exams', root)
          
            course.quizzes.each do |quiz|
              case quiz.name
                when /Practice Test$/
                  quiz_parent = practice_exams
                when /Final Exam$/
                  quiz_parent = final_exams
              end
          
              quiz_name = quiz.name.gsub(/\s+(Practice Test|Final Exam)/, '')
              AssessmentView.create(:menu_version_id => menu_version.id, :name => quiz_name, :moodle_quiz_id => quiz.id).move_to_child_of(quiz_parent)
            end
        end
      end
      
      # Version 50
      menu_version  = menu.versions.find_by_version(50)
      root          = AssessmentView.create_or_find(menu_version, menu.name)
      Moodle::Course.find_all_by_category(menu_version.moodle_course_category_id, :order => 'sortorder').each do |course|
        case course.fullname
          when /Final Exam$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Final Exams', root)
          when /Practice Exam$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Practice Exams', root)
          when /Find-the-[mM]issing [wW]ord$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Find-the-Missing Word Quizzes', root)
          when /Topic Group Tests$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Topic Group Tests', root)
        end
        
        # Subcategories
        assessment_group_name      = course.fullname.gsub(/:\s+(Final Exam|Practice Exam|Find-the-[mM]issing [wW]ord|Topic Group Tests)/, '')
        assessment_group           = AssessmentView.create_or_find(menu_version, assessment_group_name, assessment_type)
        assessment_group.sortorder = course.sortorder
        assessment_group.save!
        
        course.quizzes.each do |quiz|
          quiz.name.gsub!(/\s+(Practice ([tT]est|Exam)|Final Exam|topic group test( topic group test)?|find-the-missing word)$/, '')
          quiz.name.gsub!(/^(ARK)\s+/, '')
          quiz.name.gsub!(/:$/, '')
          AssessmentView.create(:menu_version_id => menu_version.id, :name => quiz.name, :moodle_quiz_id => quiz.id).move_to_child_of(assessment_group)
        end
      end
      
      
      # ========================================================================
      # ASE (USA)
      # ------------------------------------------------------------------------
      menu = Menu.find(2)
      
      # Version 41
      menu_version  = menu.versions.find_by_version(41)
      root          = AssessmentView.create_or_find(menu_version, menu.name)
      Moodle::Course.find_all_by_category(menu_version.moodle_course_category_id, :order => "sortorder").each do |course|
        # Version v4.1
        case course.fullname
          when /Activity Quizzes/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Find-the-Missing Word Quizzes', root)
        
            assessment_group_name = course.fullname.gsub(/\s+Activity Quizzes$/, '')
            assessment_group = AssessmentView.create_or_find(menu_version, assessment_group_name, assessment_type)
            assessment_group.sortorder = course.sortorder
            assessment_group.save!
        
            course.quizzes.each do |quiz|
              quiz.name.gsub!(/\s+(Practice ([tT]est|Exam)|Final Exam|topic group test( topic group test)?|find-the-missing word|Acti?vir?ty Quiz)$/, '')
              AssessmentView.create(:menu_version_id => menu_version.id, :name => quiz.name, :moodle_quiz_id => quiz.id).move_to_child_of(assessment_group)
            end
          
          when /Practice Tests & Final Exams/
            practice_exams = AssessmentView.create_or_find(menu_version, 'Practice Exams', root)
            final_exams    = AssessmentView.create_or_find(menu_version, 'Final Exams', root)
            
            course.quizzes.each do |quiz|
              case quiz.name
                when /Practice Test$/
                  quiz_parent = practice_exams
                when /Final Exam$/
                  quiz_parent = final_exams
              end
            
              quiz_name = quiz.name.gsub(/\s+(Practice Test|Final Exam)/, '')
              AssessmentView.create(:menu_version_id => menu_version.id, :name => quiz.name, :moodle_quiz_id => quiz.id).move_to_child_of(quiz_parent)
            end
        end
      end
      
      # Version 50
      menu_version  = menu.versions.find_by_version(50)
      root          = AssessmentView.create_or_find(menu_version, menu.name)
      Moodle::Course.find_all_by_category(menu_version.moodle_course_category_id, :order => "sortorder").each do |course|
        case course.fullname
          when /Final Exam$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Final Exams', root)
          when /Practice Exam$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Practice Exams', root)
          when /Find-the-[mM]issing [wW]ord$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Find-the-Missing Word Quizzes', root)
          when /Topic Group Tests$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Topic Group Tests', root)
        end
          
        # Subcategories
        assessment_group_name = course.fullname.gsub(/:\s+(Final Exam|Practice Exam|Find-the-[mM]issing [wW]ord|Topic Group Tests)/, '')
        assessment_group = AssessmentView.create_or_find(menu_version, assessment_group_name, assessment_type)
        assessment_group.sortorder = course.sortorder
        assessment_group.save
          
        course.quizzes.each do |quiz|
          quiz.name.gsub!(/\s+(Practice ([tT]est|Exam)|Final Exam|topic group test( topic group test)?|find-the-missing word)$/, '')
          quiz.name.gsub!(/\s+:\s+$/, '')
          AssessmentView.create(:menu_version_id => menu_version.id, :name => quiz.name, :moodle_quiz_id => quiz.id).move_to_child_of(assessment_group)
        end
      end
      
      
      # ========================================================================
      # IMI (UK)
      # ------------------------------------------------------------------------
      menu = Menu.find(3)
      
      menu_version  = menu.versions.find_by_version(41)
      root          = AssessmentView.create_or_find(menu_version, menu.name)
      Moodle::Course.find_all_by_category(menu_version.moodle_course_category_id, :order => "sortorder").each do |course|
        # Version v4.1
        case course.fullname
          when /Activity Quizzes/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Find-the-Missing Word Quizzes', root)
            quiz_parent     = assessment_type
        
            if course.fullname =~ /^IMI Level \d/
              assessment_group = AssessmentView.create_or_find(menu_version, 'Level 1', assessment_type) if course.fullname =~ /^IMI Level 1/
              assessment_group = AssessmentView.create_or_find(menu_version, 'Level 2', assessment_type) if course.fullname =~ /^IMI Level 2/
              quiz_parent      = assessment_group
            end
            quiz_parent.sortorder = course.sortorder
            quiz_parent.save
        
            assessment_subgroup_name = course.fullname.gsub(/^IMI /, '')
            assessment_subgroup_name.gsub!(/^Level \d:\s+/, '')
            assessment_subgroup_name.gsub!(/\s+Activity Quizzes$/, '')
            assessment_subgroup = AssessmentView.create_or_find(menu_version, assessment_subgroup_name, quiz_parent)
            assessment_subgroup.sortorder = course.sortorder
            assessment_subgroup.save
        
            course.quizzes.each do |quiz|
              quiz.name.gsub!(/\s+(Practice ([tT]est|Exam)|Final Exam|topic group test( topic group test)?|find-the-missing word|Acti?vity Quiz)$/, '')
              AssessmentView.create(:menu_version_id => menu_version.id, :name => quiz.name, :moodle_quiz_id => quiz.id).move_to_child_of(assessment_subgroup)
            end
          
          when /Practice Tests & Final Exams/
            practice_exams = AssessmentView.create_or_find(menu_version, 'Practice Exams', root)
            final_exams    = AssessmentView.create_or_find(menu_version, 'Final Exams', root)
          
            course.quizzes.each do |quiz|
              quiz_parent = practice_exams if quiz.name =~ /Practice Test$/
              quiz_parent = final_exams if quiz.name =~ /Final Exam$/
          
              if quiz.name =~ /^Level \d/
                assessment_group = AssessmentView.create_or_find(menu_version, 'Level 1', quiz_parent) if quiz.name =~ /^Level 1/
                assessment_group = AssessmentView.create_or_find(menu_version, 'Level 2', quiz_parent) if quiz.name =~ /^Level 2/
                quiz_parent = assessment_group
              end
          
              quiz_name = quiz.name.gsub(/^Level \d: /, '')
              quiz_name.gsub!(/\s+(Practice Test|Final Exam)/, '')
              AssessmentView.create(:menu_version_id => menu_version.id, :name => quiz.name, :moodle_quiz_id => quiz.id).move_to_child_of(quiz_parent)
            end
        end
      end
      
      # Version 50
      menu_version  = menu.versions.find_by_version(50)
      root          = AssessmentView.create_or_find(menu_version, menu.name)
      Moodle::Course.find_all_by_category(menu_version.moodle_course_category_id, :order => "sortorder").each do |course|
        case course.fullname
          when /Final Exam$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Final Exams', root)
          when /Practice Exam$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Practice Exams', root)
          when /Find-the-[mM]issing [wW]ord$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Find-the-Missing Word Quizzes', root)
          when /Topic Group Tests$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Topic Group Tests', root)
        end
          
        # Subcategories
        assessment_group_name = course.fullname.gsub(/:\s+(Final Exam|Practice Exam|Find-the-[mM]issing [wW]ord|Topic Group Tests)/, '')
        assessment_group = AssessmentView.create_or_find(menu_version, assessment_group_name, assessment_type)
        assessment_group.sortorder = course.sortorder
        assessment_group.save
          
        course.quizzes.each do |quiz|
          quiz.name.gsub!(/\s+(Practice ([tT]est|Exam)|Final Exam|topic group test( topic group test)?|find-the-missing word)$/, '')
          AssessmentView.create(:menu_version_id => menu_version.id, :name => quiz.name, :moodle_quiz_id => quiz.id).move_to_child_of(assessment_group)
        end
      end
      
      
      # ========================================================================
      # AUR (AUS)
      # ------------------------------------------------------------------------
      menu = Menu.find(4)
      
      # Version 41
      menu_version  = menu.versions.find_by_version(41)
      root          = AssessmentView.create_or_find(menu_version, menu.name)
      Moodle::Course.find_all_by_category(menu_version.moodle_course_category_id, :order => "sortorder").each do |course|
        # Version v4.1
        case course.fullname
          when /Activity Quizzes/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Find-the-Missing Word Quizzes', root)
      
            # Subcategories
            assessment_group_name      = course.fullname.gsub(/\s+Activity Quizzes.*/, '')
            assessment_group_name      = assessment_group_name.gsub(/CDX GS\+\s+/, '')
            assessment_group           = AssessmentView.create_or_find(menu_version, assessment_group_name, assessment_type)
            assessment_group.sortorder = course.sortorder
            assessment_group.save
      
            course.quizzes.each do |quiz|
              quiz.name.gsub!(/\s+(Practice ([tT]est|Exam)|Final Exam|topic group test( topic group test)?|find-the-missing word|Acti?vity Quiz)$/, '')
              AssessmentView.create(:menu_version_id => menu_version.id, :name => quiz.name, :moodle_quiz_id => quiz.id).move_to_child_of(assessment_group)
            end
          when /Practice Tests & Final Exams/
            practice_exams = AssessmentView.create_or_find(menu_version, 'Practice Exams', root)
            final_exams    = AssessmentView.create_or_find(menu_version, 'Final Exams', root)
          
            course.quizzes.each do |quiz|
              quiz_name = quiz.name.gsub(/\s+(Practice ([tT]est|Exam)|Final Exam|topic group test( topic group test)?|find-the-missing word|Acti?vity Quiz)$/, '')
              quiz_name = quiz_name.gsub(/Red Seal\s+/, '')
              quiz_name = quiz_name.gsub(/Occupation /, 'Occupational ') # Fix spelling error
              case quiz.name
                when /Practice Test$/
                  AssessmentView.create(:menu_version_id => menu_version.id, :name => quiz.name, :moodle_quiz_id => quiz.id).move_to_child_of(practice_exams)
                when /Final Exam/
                  AssessmentView.create(:menu_version_id => menu_version.id, :name => quiz.name, :moodle_quiz_id => quiz.id).move_to_child_of(final_exams)
              end
            end
        end
      end
      
      # Version 50
      menu_version  = menu.versions.find_by_version(50)
      root          = AssessmentView.create_or_find(menu_version, menu.name)
      Moodle::Course.find_all_by_category(menu_version.moodle_course_category_id, :order => "sortorder").each do |course|
        case course.fullname
          when /Final Exam$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Final Exams', root)
          when /Practice Exam$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Practice Exams', root)
          when /Find-the-[mM]issing [wW]ord$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Find-the-Missing Word Quizzes', root)
          when /Topic Group Tests$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Topic Group Tests', root)
        end
          
        # Subcategories
        assessment_group_name = course.fullname.gsub(/:\s+(Final Exam|Practice Exam|Find-the-[mM]issing [wW]ord|Topic Group Tests)/, '')
        assessment_group = AssessmentView.create_or_find(menu_version, assessment_group_name, assessment_type)
        assessment_group.sortorder = course.sortorder
        assessment_group.save
          
        course.quizzes.each do |quiz|
          quiz.name.gsub!(/\s+(Practice ([tT]est|Exam)|Final Exam|topic group test( topic group test)?|find-the-missing word)$/, '')
          AssessmentView.create(:menu_version_id => menu_version.id, :name => quiz.name, :moodle_quiz_id => quiz.id).move_to_child_of(assessment_group)
        end
      end
      
      
      # ========================================================================
      # CDX General Service
      # ------------------------------------------------------------------------
      menu    = Menu.find(5)
      
      # Version 41
      menu_version  = menu.versions.find_by_version(41)
      root          = AssessmentView.create_or_find(menu_version, menu.name)
      Moodle::Course.find_all_by_category(menu_version.moodle_course_category_id, :order => "sortorder").each do |course|
        # Version v4.1
        case course.fullname
          when /Activity Quizzes/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Find-the-Missing Word Quizzes', root)
      
            # Subcategories
            assessment_group_name = course.fullname.gsub(/\s+Activity Quizzes.*/, '')
            assessment_group_name = assessment_group_name.gsub(/CDX GS\+\s+/, '')
            assessment_group      = AssessmentView.create_or_find(menu_version, assessment_group_name, assessment_type)
            assessment_group.sortorder = course.sortorder
            assessment_group.save
      
            course.quizzes.each do |quiz|
              quiz.name.gsub!(/\s+(Practice ([tT]est|Exam)|Final Exam|topic group test( topic group test)?|find-the-missing word|Acti?vity Quiz)$/, '')
              AssessmentView.create(:menu_version_id => menu_version.id, :name => quiz.name, :moodle_quiz_id => quiz.id).move_to_child_of(assessment_group)
            end
          when /Practice Tests & Final Exams/
            practice_exams = AssessmentView.create_or_find(menu_version, 'Practice Exams', root)
            final_exams    = AssessmentView.create_or_find(menu_version, 'Final Exams', root)
          
            course.quizzes.each do |quiz|
              quiz_name = quiz.name.gsub(/\s+(Practice ([tT]est|Exam)|Final Exam|topic group test( topic group test)?|find-the-missing word|Acti?vity Quiz)$/, '')
              quiz_name = quiz_name.gsub(/Red Seal\s+/, '')
              quiz_name = quiz_name.gsub(/Occupation /, 'Occupational ') # Fix spelling error
              case quiz.name
                when /Practice Test$/
                  AssessmentView.create(:menu_version_id => menu_version.id, :name => quiz.name, :moodle_quiz_id => quiz.id).move_to_child_of(practice_exams)
                when /Final Exam/
                  AssessmentView.create(:menu_version_id => menu_version.id, :name => quiz.name, :moodle_quiz_id => quiz.id).move_to_child_of(final_exams)
              end
            end
        end
      end
      
      # Version 50
      menu_version  = menu.versions.find_by_version(50)
      root          = AssessmentView.create_or_find(menu_version, menu.name)
      Moodle::Course.find_all_by_category(menu_version.moodle_course_category_id, :order => "sortorder").each do |course|
        case course.fullname
          when /Final Exam$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Final Exams', root)
          when /Practice Exam$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Practice Exams', root)
          when /Find-the-[mM]issing [wW]ord$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Find-the-Missing Word Quizzes', root)
          when /Topic Group Tests$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Topic Group Tests', root)
        end
          
        # Subcategories
        assessment_group_name = course.fullname.gsub(/:\s+(Final Exam|Practice Exam|Find-the-[mM]issing [wW]ord|Topic Group Tests)/, '')
        assessment_group = AssessmentView.create_or_find(menu_version, assessment_group_name, assessment_type)
        assessment_group.sortorder = course.sortorder
        assessment_group.save
          
        course.quizzes.each do |quiz|
          quiz.name.gsub!(/\s+(Practice ([tT]est|Exam)|Final Exam|topic group test( topic group test)?|find-the-missing word)$/, '')
          AssessmentView.create(:menu_version_id => menu_version.id, :name => quiz.name, :moodle_quiz_id => quiz.id).move_to_child_of(assessment_group)
        end
      end
      
      
      # ========================================================================
      # Read Seal (CAN)
      # ------------------------------------------------------------------------
      menu = Menu.find(6)
      
      # Version 41
      menu_version  = menu.versions.find_by_version(41)
      root          = AssessmentView.create_or_find(menu_version, menu.name)
      Moodle::Course.find_all_by_category(menu_version.moodle_course_category_id, :order => "sortorder").each do |course|
        case course.fullname
          when /Activity Quizzes/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Find-the-Missing Word Quizzes', root)
      
            # Subcategories
            assessment_group_name = course.fullname.gsub(/\s+Activity Quizzes.*/, '')
            assessment_group_name = assessment_group_name.gsub(/Red Seal\s+/, '')
            assessment_group      = AssessmentView.create_or_find(menu_version, assessment_group_name, assessment_type)
            quiz_parent           = assessment_group
      
            if course.fullname =~ /Part \d$/
              assessment_subgroup = AssessmentView.create_or_find(menu_version, 'Part 1', assessment_group) if course.fullname =~ /Part 1$/
              assessment_subgroup = AssessmentView.create_or_find(menu_version, 'Part 2', assessment_group) if course.fullname =~ /Part 2$/
              quiz_parent         = assessment_subgroup
            end
            quiz_parent.sortorder = course.sortorder
            quiz_parent.save
      
            course.quizzes.each do |quiz|
              quiz.name.gsub!(/\s+(Practice ([tT]est|Exam)|Final Exam|topic group test( topic group test)?|find-the-missing word|Acti?vity Quiz)$/, '')
              AssessmentView.create(:menu_version_id => menu_version.id, :name => quiz.name, :moodle_quiz_id => quiz.id).move_to_child_of(quiz_parent)
            end
        
          when /Practice and Final Exams/
            practice_exams = AssessmentView.create_or_find(menu_version, 'Practice Exams', root)
            final_exams    = AssessmentView.create_or_find(menu_version, 'Final Exams', root)
        
            course.quizzes.each do |quiz|
              quiz_name = quiz.name.gsub(/\s+(Practice ([tT]est|Exam)|Final Exam|topic group test( topic group test)?|find-the-missing word|Acti?vity Quiz)$/, '')
              quiz_name = quiz_name.gsub(/Red Seal\s+/, '')
              quiz_name = quiz_name.gsub(/Occupation /, 'Occupational ') # Fix spelling error
              case quiz.name
                when /Practice Test$/
                  AssessmentView.create(:menu_version_id => menu_version.id, :name => quiz.name, :moodle_quiz_id => quiz.id).move_to_child_of(practice_exams)
                when /Final Exam/
                  AssessmentView.create(:menu_version_id => menu_version.id, :name => quiz.name, :moodle_quiz_id => quiz.id).move_to_child_of(final_exams)
                end
            end
        end
      end
      
      # Version 50
      #
      # Red Seal Occupational Skills: Find-the-Missing Word pt1
      #
      menu_version  = menu.versions.find_by_version(50)
      root          = AssessmentView.create_or_find(menu_version, menu.name)
      Moodle::Course.find_all_by_category(menu_version.moodle_course_category_id, :order => "sortorder").each do |course|
        case course.fullname
          when /Topic Group Tests/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Topic Group Tests', root)
          when /Find-[tT]he-[mM]issing [wW]ord/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Find-the-Missing Word Quizzes', root)
          when /Practice Exam$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Practice Exams', root)
          when /Final Exam$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Final Exams', root)
        end
        
        # Subcategories
        assessment_group_name = course.fullname.gsub(/:\s+(Final Exam|Practice Exam|Find-[tT]he-[mM]issing [wW]ord|Topic Group Tests?)/, '')
        assessment_group_name.gsub!(/Red Seal\s+/, '')
        
        # We need to separate the non-standard 'parts' out. Arghhh.
        #
        # NOTE: Overly verbose for clarity
        case assessment_group_name
          when /\s+(pt1|Pt.1)/
            part_name = 'Part 1'                            # Register the part name
            assessment_group_name.gsub!(/\s+(pt1|Pt.1)/,'') # Remove the part number from the name
          when /\s+(pt2|Pt.2)/
            part_name = 'Part 2'                            # Register the part name
            assessment_group_name.gsub!(/\s+(pt2|Pt.2)/,'') # Remove the part number from the name
          else
            part_name = nil
        end
        
        # Create the group
        assessment_group           = AssessmentView.create_or_find(menu_version, assessment_group_name.strip, assessment_type)
        assessment_group.sortorder = course.sortorder
        assessment_group.save!
        
        # If we have a part tag, make sure create the part sub-group
        if part_name
          parent_group      = assessment_group
          assessment_group  = AssessmentView.create_or_find(menu_version, part_name, assessment_type)
          assessment_group.move_to_child_of(parent_group)
        end
        
        # Now add all of the quizzes to the 
        course.quizzes.each do |quiz|
          quiz.name.gsub!(/\s+(Practice ([tT]est|Exam)|Final Exam|topic group test( topic group test)?|find-the-missing word)$/, '')
          quiz.name.gsub!(/Red Seal\s+/, '')
          
          AssessmentView.create(:menu_version_id  => menu_version.id, 
                                :name             => quiz.name, 
                                :moodle_quiz_id   => quiz.id).move_to_child_of(assessment_group)
        end
      end
      
      
      # ========================================================================
      # NZ
      # ------------------------------------------------------------------------
      menu = Menu.find(9)
      
      # Version 50
      menu_version  = menu.versions.find_by_version(50)
      root          = AssessmentView.create_or_find(menu_version, menu.name)
      Moodle::Course.find_all_by_category(menu_version.moodle_course_category_id, :order => "sortorder").each do |course|
        case course.fullname
          when /Final Exam$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Final Exams', root)
          when /Practice Exam$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Practice Exams', root)
          when /Find-the-[mM]issing [wW]ord$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Find-the-Missing Word Quizzes', root)
          when /Topic Group Tests$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Topic Group Tests', root)
        end
          
        # Subcategories
        assessment_group_name = course.fullname.gsub(/:\s+(Final Exam|Practice Exam|Find-the-[mM]issing [wW]ord|Topic Group Tests)/, '')
        assessment_group = AssessmentView.create_or_find(menu_version, assessment_group_name, assessment_type)
        assessment_group.sortorder = course.sortorder
        assessment_group.save
          
        course.quizzes.each do |quiz|
          quiz.name.gsub!(/\s+(Practice ([tT]est|Exam)|Final Exam|topic group test( topic group test)?|find-the-missing word)$/, '')
          AssessmentView.create(:menu_version_id => menu_version.id, :name => quiz.name, :moodle_quiz_id => quiz.id).move_to_child_of(assessment_group)
        end
      end
      
      
      # ========================================================================
      # Pearson
      # ------------------------------------------------------------------------
      menu = Menu.find(8)
      
      # Version 50
      menu_version  = menu.versions.find_by_version(50)
      root          = AssessmentView.create_or_find(menu_version, menu.name)
      Moodle::Course.find_all_by_category(menu_version.moodle_course_category_id, :order => "sortorder").each do |course|
        case course.fullname
          when /Final Exam$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Final Exams', root)
          when /Practice Exam$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Practice Exams', root)
          when /Find-the-[mM]issing [wW]ord$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Find-the-Missing Word Quizzes', root)
          when /Topic Group Tests$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Topic Group Tests', root)
        end
          
        # Subcategories
        assessment_group_name = course.fullname.gsub(/:\s+(Final Exam|Practice Exam|Find-the-[mM]issing [wW]ord|Topic Group Tests)/, '')
        assessment_group = AssessmentView.create_or_find(menu_version, assessment_group_name, assessment_type)
        assessment_group.sortorder = course.sortorder
        assessment_group.save
          
        course.quizzes.each do |quiz|
          quiz.name.gsub!(/\s+(Practice ([tT]est|Exam)|Final Exam|topic group test( topic group test)?|find-the-missing word)$/, '')
          AssessmentView.create(:menu_version_id => menu_version.id, :name => quiz.name, :moodle_quiz_id => quiz.id).move_to_child_of(assessment_group)
        end
      end
      
      
      # ========================================================================
      # Ontario
      # ------------------------------------------------------------------------
      menu = Menu.find(13)
      
      # Version 50
      menu_version  = menu.versions.find_by_version(50)
      root          = AssessmentView.create_or_find(menu_version, menu.name)
      Moodle::Course.find_all_by_category(menu_version.moodle_course_category_id, :order => "sortorder").each do |course|
        case course.fullname
          when /Final Exam$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Final Exams', root)
          when /Practice Exam$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Practice Exams', root)
          when /Find-the-[mM]issing [wW]ord$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Find-the-Missing Word Quizzes', root)
          when /Topic Group Tests$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Topic Group Tests', root)
        end
          
        # Subcategories
        assessment_group_name = course.fullname.gsub(/:\s+(Final Exam|Practice Exam|Find-the-[mM]issing [wW]ord|Topic Group Tests)/, '')
        assessment_group = AssessmentView.create_or_find(menu_version, assessment_group_name, assessment_type)
        assessment_group.sortorder = course.sortorder
        assessment_group.save
          
        course.quizzes.each do |quiz|
          quiz.name.gsub!(/\s+(Practice ([tT]est|Exam)|Final Exam|topic group test( topic group test)?|find-the-missing word)$/, '')
          quiz.name.gsub!(/^(ARK)\s+/, '')
          quiz.name.gsub!(/\s+:\s+$/, '')
          AssessmentView.create(:menu_version_id => menu_version.id, :name => quiz.name, :moodle_quiz_id => quiz.id).move_to_child_of(assessment_group)
        end
      end
      
      
      # ========================================================================
      # MITO (NZ)
      # ------------------------------------------------------------------------
      # Moodle::Base.setup_tables_by_database('moodle_mito_master')
      # 
      # menu = Menu.find(7)
      # 
      # # Version 50
      # version       = 50
      # menu_version  = menu.versions.find_by_version(version)
      # root          = AssessmentView.create_or_find(menu_version, menu.name)
      # Moodle::Course.find_all_by_category(menu_version.moodle_course_category_id, :order => "sortorder").each do |course|
      #   case course.fullname
      #     when /Final Exam$/
      #       assessment_type = AssessmentView.create_or_find(menu_version, 'Final Exams', root)
      #     when /Practice Exam$/
      #       assessment_type = AssessmentView.create_or_find(menu_version, 'Practice Exams', root)
      #     when /Find-the-[mM]issing [wW]ord$/
      #       assessment_type = AssessmentView.create_or_find(menu_version, 'Find-the-Missing Word Quizzes', root)
      #     when /Topic Group Tests$/
      #       assessment_type = AssessmentView.create_or_find(menu_version, 'Topic Group Tests', root)
      #   end
      #   
      #   # Subcategories
      #   assessment_group_name = course.fullname.gsub(/:\s+(Final Exam|Practice Exam|Find-the-[mM]issing [wW]ord|Topic Group Tests)/, '')
      #   assessment_group = AssessmentView.create_or_find(menu_version, assessment_group_name, assessment_type)
      #   assessment_group.sortorder = course.sortorder
      #   assessment_group.save!
      #   
      #   course.quizzes.each do |quiz|
      #     quiz.name.gsub!(/\s+(Practice ([tT]est|Exam)|Final Exam|topic group test( topic group test)?|find-the-missing word)$/, '')
      #     AssessmentView.create(:menu_version_id => menu_version.id, :name => quiz.name, :moodle_quiz_id => quiz.id).move_to_child_of(assessment_group)
      #   end
      # end
      
    end # transaction
  end # def
  
  protected
  
    def self.create_or_find(menu_version, name, parent = nil)
      view = menu_version.assessment_views.first( :conditions => { :name => name, :parent_id => parent.try(:id) })

      if view.blank?
        view = menu_version.assessment_views.create(:name => name) 
        view.move_to_child_of(parent) if parent.present?
      end

      view
    end
    
    def self.build_standardised_51_view(menu)
      
      # Version 51
      menu_version  = menu.versions.find_by_version(51)
      root          = AssessmentView.create_or_find(menu_version, menu.name)
      
      Moodle::Course.find_all_by_category(menu_version.moodle_course_category_id, :order => 'sortorder').each do |course|
        case course.fullname
          when /Topic Group Test$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Topic Group Tests', root)
          when /Find-The-Missing Word$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Find-the-Missing Word Quizzes', root)
          when /Practice Exam$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Practice Exams', root)
          when /Final Exam$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Final Exams', root)
        end
        
        # puts "|- #{assessment_type.name}"
        
        # Parse the Quizzes and Tests name (TGT/FTMW/PE/FE)
        assessment_group_name      = course.fullname.gsub(/:\s+(Final Exam|Practice Exam|Find-The-Missing Word|Topic Group Test)/, '')
        assessment_group           = AssessmentView.create_or_find(menu_version, assessment_group_name, assessment_type)
        assessment_group.sortorder = course.sortorder
        assessment_group.save!
        
        # puts "  |- #{assessment_group_name}"
        
        # Iterate through each of the individual "Topics" (moodle) under the quiz/test
        course.quizzes.each do |quiz|
          quiz.name.gsub!(/\s+(topic group test|find-the-missing word|Practice Exam|Final Exam)$/, '')
          quiz.name.gsub!(/:/, '')
          
          # puts "    |- #{quiz.name}"
          
          # Create "topic" underneath the assessment group (quiz)
          AssessmentView.create(:menu_version_id => menu_version.id, :name => quiz.name, :moodle_quiz_id => quiz.id).move_to_child_of(assessment_group)
        end
      end
      
      nil
    end

    def self.build_standardised_51_view_with_parts(menu)
      # Version 51
      menu_version = menu.versions.find_by_version(51)
      root         = AssessmentView.create_or_find(menu_version, menu.name)
      # puts menu.name
      
      Moodle::Course.find_all_by_category(menu_version.moodle_course_category_id, :order => 'sortorder').each do |course|
        case course.fullname
          when /Topic Group Test/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Topic Group Tests', root)
          when /Find-The-Missing Word/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Find-the-Missing Word Quizzes', root)
          when /Practice Exam$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Practice Exams', root)
          when /Final Exam$/
            assessment_type = AssessmentView.create_or_find(menu_version, 'Final Exams', root)
        end
        # puts "|- #{assessment_type.name} [#{course.id}]"
        
        # Parse the Quizzes and Tests name (TGT/FTMW/PE/FE)
        assessment_group_name = course.fullname.gsub(/:\s+(Final Exam|Practice Exam|Find-The-Missing Word|Topic Group Test)/, '')
        
        # We need to separate the non-standard 'parts' out. Arghhh.
        #
        # NOTE: Overly verbose for clarity
        part_name = nil
        case assessment_group_name
          when /[pP]t\.?1/
            part_name = 'Part 1'                            # Register the part name
            assessment_group_name.gsub!(/\s*[pP]t\.?1\s*/,'') # Remove the part number from the name
          when /[pP]t\.?2/
            part_name = 'Part 2'                            # Register the part name
            assessment_group_name.gsub!(/\s*[pP]t\.?2\s*/,'') # Remove the part number from the name
          when /[pP]t\.?3/
            part_name = 'Part 3'                            # Register the part name
            assessment_group_name.gsub!(/\s*[pP]t\.?3\s*/,'') # Remove the part number from the name
        end
        
        # puts "  |- #{assessment_group_name} [#{course.id}]"
        assessment_group      = AssessmentView.create_or_find(menu_version, assessment_group_name, assessment_type)
        assessment_group.name      = assessment_group_name
        assessment_group.sortorder = course.sortorder
        assessment_group.save!
        
        
        # If we have a part tag, make sure create the part sub-group
        if part_name.present?
          # puts "    (#{part_name})"
          parent_group     = assessment_group
          assessment_group = AssessmentView.create_or_find(menu_version, part_name, assessment_type)
          assessment_group.move_to_child_of(parent_group)
        end
        
        # Iterate through each of the individual "Topics" (moodle) under the quiz/test
        course.quizzes.each do |quiz|
          quiz.name.gsub!(/\s+(topic group test|find-the-missing word|Practice Exam|Final Exam)$/, '')
          ## duplicate to clean up bad layout file - remove on reimport
          quiz.name.gsub!(/\s+(topic group test|find-the-missing word|Practice Exam|Final Exam)$/, '')
          ###
          quiz.name.gsub!(/:/, '')
          
          # puts "    |- #{quiz.name}"
          
          # Create "topic" underneath the assessment group (quiz)
          AssessmentView.create(:menu_version_id => menu_version.id, :name => quiz.name, :moodle_quiz_id => quiz.id).move_to_child_of(assessment_group)
        end
      end
    end
end

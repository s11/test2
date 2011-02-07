#!/usr/bin/env ruby

#--
#  quiz_importer
#  
#  *Very* rough tool to import quiz questions into Moodle.
#  Things to fix if there's time:
#    - Hardcoded paths (change to input parameters)
#    - Optimise GIFT processing to use REGEX instead of string ops
#    - Parse GIFTs into XML format (http://docs.moodle.org/en/Moodle_XML_format)
#    - General clean up of the coding spaz below
#  
#  Created by Robert O'Farrell on 2009-07-15.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++

require 'optparse'

options   = { :environment => (ENV['RAILS_ENV'] || 'development').dup }
optparse  = OptionParser.new do |opts|
  opts.banner = 'Usage: import [options]'
  
  options[:structure_filename_with_path] = nil
  opts.on( '-s', '--structure CSV_FILENAME', 'Course structure CSV file' ) do |filename|
    options[:structure_filename_with_path] = filename
  end
  
  options[:gifts_filename_with_path] = nil
  opts.on( '-g', '--gift CSV_FILENAME', 'Course GIFTs CSV file' ) do |filename|
    options[:gifts_filename_with_path] = filename
  end
  
  options[:database] = 'moodle_a620'
  opts.on( '-d', '--database NAME', 'Database to import the content into.' ) do |database|
    options[:version] = database
  end
  
  options[:version] = '51'
  opts.on( '-v', '--version VERSION', 'Version of the quizzes and tests being imported' ) do |version|
    options[:version] = version
  end
  
  opts.on_tail( '-h', '--help', 'Show this message' ) do
    puts opts
    exit
  end
end

optparse.parse!

##

puts 'Loading management environment.'

require File.dirname(__FILE__) + '/../../config/boot'

# Make sure we have the correct environment. Default to 'development'.
ENV['RAILS_ENV'] = options[:environment]

RAILS_ENV.replace(options[:environment]) if defined?(RAILS_ENV)

require RAILS_ROOT + '/config/environment'
require RAILS_ROOT + '/tools/moodle/lib.rb'

require 'rubygems'
require 'sequel'
require 'fastercsv'
require 'cgi'

MAX_NO_TESTS_IN_GROUP = 40

DB = Sequel.connect("mysql://root:24nokTurn11@localhost/#{options[:database]}")

csv_path  = RAILS_ROOT + '/tools/moodle/materials/layout/'
gift_path = RAILS_ROOT + '/tools/moodle/materials/gifts/'

@gift_tree      = {}
@exam_questions = {}
@exam_gifts     = []
@course_id      = 0
@quiz_id        = 0
@num_quizzes    = 0

# Load the course/gift tree
puts 'Building GIFT tree ...'
FasterCSV.foreach(options[:gifts_filename_with_path], {:headers => :first_row}) do |row|
  unless row['map'].nil?
    @gift_tree[row['map']] = {}
    @map = row['map']
  end
  unless row['category'].nil?
    @gift_tree[@map][row['category']] = {}
    @category = row['category']
  end
  unless row['test_type'].nil?
    @gift_tree[@map][@category][row['test_type']] = {}
    @test_type = row['test_type']
  end
  unless row['qn_category'].nil? or row['gift_filename'].nil?
    @gift_tree[@map][@category][@test_type][row['qn_category']] = row['gift_filename']
  end
end

# pp @gift_tree

@map_layout = {}
@map        = ''
@menu       = ''
@category   = ''
@test_type  = ''

@category_indx  = nil
@test_type_indx = nil

puts 'Building layout tree ...'
FasterCSV.foreach(options[:structure_filename_with_path], {:headers => :first_row}) do |row|
  unless row['menu'].nil?
    @map_layout[row['menu']] = {
      :map_name       => row['map'],
      :cdx_menu_name  => row['cdx_menu_name'],
      :categories     => [],
    }
    @menu           = row['menu']
    @category_indx  = nil
  end
  unless row['category'].nil?
    @map_layout[@menu][:categories] << {
      :name       => row['category'],
      :shortname  => row['shortname'],
      :test_types => [] # Used instead of a Hash to maintain the order of insertion
    }
    @category_indx  = (@category_indx.nil? ? 0 : @category_indx + 1)
    @test_type_indx = nil
  end
  unless row['test_type'].nil?
    @map_layout[@menu][:categories][@category_indx][:test_types] << {
      :name         => row['test_type'],
      :abbreviation => row['test_type_abbr'],
      :tests        => [] # Used instead of a Hash to maintain the order of insertion
    }
    @test_type_indx = (@test_type_indx.nil? ? 0 : @test_type_indx + 1)
  end
  unless row['quiz'].nil?
    @map_layout[@menu][:categories][@category_indx][:test_types][@test_type_indx][:tests] << {row['quiz'] => row['qn_category']}
  end
end

# pp @map_layout

puts 'Importing Quizzes and Tests into Moodle ...'
@map_layout.each_pair do |menu_name, menu|
  
  map_name    = menu[:map_name]
  category_id = create_course_category(map_name)
  
  puts "+ Added #{map_name} with ID: #{category_id}"
  
  # Iterate through the categories
  menu[:categories].each do |category|
    exam_questions  = {}
    exam_gifts      = []

    category_name       = category[:name]
    category_shortname  = category[:shortname]
    
    # Iterate through the test types
    category[:test_types].each do |test_type|
      
      test_type_name  = test_type[:name]
      test_type_abbr  = test_type[:abbreviation]
      fullname        = "#{category_name}: #{test_type_name}"
      shortname       = "#{category_shortname}#{test_type_abbr}"
      num_quizzes     = 0
      
      # If there's more than 40 tests for any group we need to split them up
      # into Pt.1/Pt.2/Pt.3 etc with an even distribution of tests in each group
      
      course_ids  = []
      num_tests   = test_type[:tests].length
      
      if num_tests > MAX_NO_TESTS_IN_GROUP
        num_groups = (num_tests/MAX_NO_TESTS_IN_GROUP.to_f).ceil
        num_groups.times do |i|
          part_no = i + 1
          course_ids << create_course(category_id, "#{fullname} Pt.#{part_no}", "#{shortname}pt#{part_no}")
        end
      else
        puts " + Adding #{category_name}: #{test_type_name}"
        course_ids << create_course(category_id, fullname, shortname)
      end
      
      course_id       = course_ids[0]
      quizzes_per_cat = (num_tests/course_ids.length.to_f).ceil # How many quizzes should be in each group
      num_quizzes     = 0
      
      # Iterate through the quizzess in each test type
      test_type[:tests].each do |quiz|
        
        # Adjust the course_id and reset the quiz_no if necessary
        if num_quizzes.eql?(quizzes_per_cat)
          course_id   = course_ids[(course_ids.index(course_id)+1)]
          num_quizzes = 1
        else
          num_quizzes = num_quizzes + 1
        end
        
        # Probably a better way to store the quiz/qn_category pairs
        quiz_name     = quiz.keys[0]
        quiz_gift_ref = quiz.values[0]
        
        puts " + Adding #{test_type_abbr} quiz: #{quiz_name}"
        
        # Determine where to source the GIFTs from
        adj_abbr          = (['PE', 'FE'].include?(test_type_abbr) ? 'TGT' : test_type_abbr)
        master_gift_dirs  = [gift_path + "#{adj_abbr.downcase}/ark/", gift_path + "#{adj_abbr.downcase}/gs/"] # ARK + GS
        menu_gift_dir     = gift_path + "#{adj_abbr.downcase}/#{menu_name}/"
        
        case test_type_abbr
        when 'TGT': # Topic Group Test
          
          quiz_config = {
            :questionsperpage => 0,
            :sumgrades        => 5,
            :grade            => 5,
          } # Defaults: attempts=0, delay1=0, delay2=0
          
          # Create the quiz
          name    = "#{quiz_name} #{test_type_name.downcase}"
          quiz_id = create_quiz(course_id, name, num_quizzes, quiz_config)
          
          # Create the question category
          qn_category_id = create_question_category(course_id, quiz_gift_ref)
          
          # Get the correct path to the GIFT file
          # puts @gift_tree[map_name][category_name]
          # puts '..'
          # puts @gift_tree[map_name][category_name][test_type_name]
          # puts '..'
          # puts @gift_tree[map_name][category_name][test_type_name][quiz_name]
          
          gift_filename = @gift_tree[map_name][category_name][test_type_name][quiz_gift_ref]
          gift_dir      = find_gift_file(gift_filename, [menu_gift_dir] + master_gift_dirs)
          if gift_dir.nil?
            puts "  ! #{gift_filename} GIFT file not found.  Could not be found in either #{menu_gift_dir} or #{master_gift_dirs.to_s}."
            next
          end
          
          # Extract the information from the gift file
          questions = process_gift(gift_dir + gift_filename)
          exam_questions.merge!(questions)   # Append these questions to the exam set
          exam_gifts << gift_filename        # Append the GIFT filename
          
          # Create the multichoice question
          questions.each_pair do |name, question| 
            create_multichoice_question(qn_category_id, name, question[:questiontext], question[:answers])
          end
          
          # Create 5 random questions and assign them to the new quiz
          puts '  + Generating random questions for quiz ...'
          create_random_questions(qn_category_id, quiz_id, 5)
          
        when 'FTMW': # Find-The-Missing Word
      
          quiz_config = {
            :questionsperpage => 0,
            :sumgrades        => nil,
            :grade            => 10,
          } # Defaults: attempts=0, delay1=0, delay2=0
      
          # Get the correct path to the GIFT file
          gift_filename = @gift_tree[map_name][category_name][test_type_name][quiz_gift_ref]
          gift_dir      = find_gift_file(gift_filename, [menu_gift_dir] + master_gift_dirs)
          if gift_dir.nil?
            puts "  ! #{gift_filename} GIFT file not found.  Could not be found in either #{menu_gift_dir} or #{master_gift_dirs.to_s}."
            next
          end
      
          # Extract the information from the gift file
          questions = process_gift(gift_dir + gift_filename)
      
          # Figure out how many questions should be in the quiz
          # KLUDGE: Should be encapsulated in a function
          num_questions = questions.length
          num_questions = (num_questions * 0.9).to_i                              # reduce by 10%
          num_questions = ((num_questions/10).floor)*10 unless num_questions < 10 # round down to the nearest 10
          num_questions = 20 if num_questions >= 20
      
          quiz_config[:sumgrades] = num_questions
      
          # Create the quiz
          name    = "#{quiz_name} #{test_type_name.downcase}"
          quiz_id = create_quiz(course_id, name, num_quizzes, quiz_config)
      
          # Create the questions category
          qn_category_id  = create_question_category(course_id, quiz_gift_ref)
        
          # Create the multichoice question
          questions.each_pair do |name, question| 
            create_findthemissingword_question(qn_category_id, name, question[:questiontext], question[:answers])
          end
      
          # Create 5 random questions and assign them to the new quiz
          puts "  + Generating #{num_questions} random questions from #{questions.length} for quiz ..."
          create_random_questions(qn_category_id, quiz_id, num_questions)
      
        when 'PE': # Practice Exam
      
          quiz_config = {
            :questionsperpage => 0,
            :sumgrades        => 10,
            :grade            => 10,
            :delay1           => 1800,  # 30 minutes
            :delay2           => 1800   # 30 minutes
          } # Defaults: attempts=0
      
          # Create the quiz
          name    = "#{quiz_name} #{test_type_name}"
          quiz_id = create_quiz(course_id, name, num_quizzes, quiz_config)
      
          # Create the question category
          qn_category_id = create_question_category(course_id, quiz_gift_ref)
      
          # Load any missing gifts
          # NOTE: Assume that there's always a PE for FE and that PE always proceeds FE
          @gift_tree[map_name][category_name]['Topic Group Test'].each_pair do |category, gift_filename|
            unless exam_gifts.include?(gift_filename)
              gift_dir = find_gift_file(gift_filename, [menu_gift_dir] + master_gift_dirs)
              if gift_dir.nil?
                puts "  ! #{gift_filename} GIFT file not found.  Could not be found in either #{menu_gift_dir} or #{master_gift_dirs.to_s}."
              else
                puts " + Adding missing GIFT #{gift_filename} ..."
                questions = process_gift(gift_dir + gift_filename)
                exam_questions.merge!(questions)
              end
            end
          end
      
          # Input the exam questions
          exam_questions.each_pair do |name, question| 
            create_multichoice_question(qn_category_id, name, question[:questiontext], question[:answers])
          end
      
          # Create the random questions
          create_random_questions(qn_category_id, quiz_id, 10)
      
        when 'FE': # Final Exam
      
          quiz_config = {
            :attempts         => 3,
            :questionsperpage => 0,
            :sumgrades        => nil,
            :grade            => 50,
            :timelimit        => 50,
            :delay1           => 1800,  # 30 minutes
            :delay2           => 1800   # 30 minutes
          } # Defaults: none
      
          # Figure out how many questions should be in the quiz
          num_questions = exam_questions.length
          num_questions = (num_questions * 0.9).to_i                              # reduce by 10%
          num_questions = ((num_questions/10).floor)*10 unless num_questions < 10 # round down to the nearest 10
          num_questions = 50 if num_questions >= 50
      
          quiz_config[:sumgrades] = num_questions
      
          # Create the quiz
          name    = "#{quiz_name} #{test_type_name}"
          quiz_id = create_quiz(course_id, name, num_quizzes, quiz_config)
      
          # Create the question category
          qn_category_id = create_question_category(course_id, quiz_gift_ref)
      
          # Input the exam questions
          exam_questions.each_pair do |name, question| 
            create_multichoice_question(qn_category_id, name, question[:questiontext], question[:answers])
          end
      
          # Create the random questions
          create_random_questions(qn_category_id, quiz_id, num_questions)
        end
        
      end
      
    end # test_types
  end # categories
  
  # Add the new moodle category id to `menu_versions` in `content_reporting`
  menu_version = Menu.find_by_name(menu[:cdx_menu_name]).versions.find_by_version(options[:version])
  menu_version.moodle_course_category_id = category_id
  menu_version.save!
  
end # menus
#--
#  lib.rb
#  
#  Set of methods to make the import tool a little more manageable
#  
#  Created by Robert O'Farrell on 2009-07-15.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++

def create_course_category( name )

  next_id           = next_autoincrement_id(:cdx_course_categories)
  course_categories = DB[:cdx_course_categories].insert(:name => name, :path => "/#{next_id}")
  
  next_autoincrement_id(:cdx_course_categories) - 1

end

def create_course( category_id, fullname, shortname )

  course = DB[:cdx_course]
  course.insert(:category     => category_id, 
                :sortorder    => course.max(:sortorder) + 1,
                :fullname     => fullname,
                :shortname    => shortname,
                :numsections  => 0,
                :password     => '', 
                :idnumber     => '',
                :lang         => '',
                :theme        => '',
                :cost         => '',
                :enrol        => '')
  
  next_autoincrement_id(:cdx_course) - 1

end

def create_quiz( course_id, name, num_quizzes, configuration = {} )
  
  quiz_defaults = {
    :course            => course_id,
    :name              => name,
    :shufflequestions  => 1,
    :shuffleanswers    => 1,
    :password          => '',
    :subnet            => '',
    :review            => 195567
  }.merge!(configuration)
  
  # Update the course with a new section
  course = DB[:cdx_course]
  course.filter(:id => course_id).update(:numsections => :numsections + 1)
  
  # "{i:3797;O:8:\"stdClass\":6:{s:2:\"cm\";i:3797;s:3:\"mod\";s:4:\"quiz\";s:7:\"section\";s:1:\"0\";s:4:\"name\";s:9:\"Test+quiz\";s:7:\"visible\";s:1:\"1\";s:5:\"extra\";s:0:\"\";}"
  modinfo_template = "i:ID;O:8:\"stdClass\":6:{s:2:\"cm\";i:ID;s:3:\"mod\";s:4:\"quiz\";s:7:\"section\";s:SEQ_LEN:\"SEQ_NO\";s:4:\"name\";s:QNAME_LEN:\"QNAME_STR\";s:7:\"visible\";s:1:\"1\";s:5:\"extra\";s:0:\"\";}"
  
  # Create the quiz
  quiz    = DB[:cdx_quiz]
  quiz.insert(quiz_defaults)
  quiz_id = quiz.max(:id)
  
  # Create the course section
  course_sections = DB[:cdx_course_sections]
  course_sections.insert( :course   => course_id,
                          :section  => num_quizzes)
  course_section_id = course_sections.max(:id)
  
  # Create the course module
  course_modules = DB[:cdx_course_modules]
  course_modules.insert(:course   => course_id,
                        :module   => 12,
                        :instance => quiz_id,
                        :section  => course_section_id)
  
  # Update the section with the module id
  course_module_id = course_modules.max(:id)
  course_sections.filter(:id => course_section_id).update(:sequence => course_module_id)
  
  # Update the course so it knows about the new quiz
  modinfo = course[:id => course_id][:modinfo]
  
  # Insert the new information
  modinfo_template.gsub!('ID',        course_module_id.to_s)
  modinfo_template.gsub!('QNAME_STR', CGI.escape(name))
  modinfo_template.gsub!('QNAME_LEN', CGI.escape(name).length.to_s)
  modinfo_template.gsub!('SEQ_NO',    num_quizzes.to_s)
  modinfo_template.gsub!('SEQ_LEN',   num_quizzes.to_s.length.to_s)
  
  new_modinfo = if modinfo.nil?
    "a:1:{" + modinfo_template + "}"
  else
    # This is fucked up - use a regex dipshit
    front_truncate  = "a:#{num_quizzes - 1}:{"
    "a:#{num_quizzes}:{" + modinfo[front_truncate.length, modinfo.length - front_truncate.length - 1] + modinfo_template + "}"
  end
  
  # Update the course with the new modinfo
  course.filter(:id => course_id).update(:modinfo => new_modinfo)
  
  quiz_id
  
end

def create_question_category( course_id, name )

  question_categories = DB[:cdx_question_categories]
  question_categories.insert(:course => course_id, :name => name, :stamp => moodle_stamp)
  
  next_autoincrement_id(:cdx_question_categories) - 1

end

def create_multichoice_question( category_id, name, text, answers )
  
  single          = 1     # Default: There is only one correct answer
  shuffle_answers = true  # Default: Do unless this is a Tech A/Tech B question
  
  # Create the question
  question = DB[:cdx_question]
  question.insert(:category     => category_id,
                  :name         => name,
                  :questiontext => text,
                  :qtype        => 'multichoice',
                  :stamp        => moodle_stamp,
                  :version      => moodle_stamp)
  question_id = question.max(:id)
  
  # Create the answers
  answer_ids = []
  answers.each_with_index do |answer, indx|
    answers = DB[:cdx_question_answers]
    answers.insert( :question => question_id, 
                    :answer   => answer[:text],
                    :fraction => answer[:result],
                    :feedback => answer[:feedback])
    
    answer_ids << (next_autoincrement_id(:cdx_question_answers) - 1)
    
    # Check the fraction of the result.  If it's neither right (1) or wrong (0)
    # then we flag the question as having multiple answers
    single = 0 if answer[:result].to_f > 0 and answer[:result].to_f < 1
    
    # Check whether the *first* answer matches "Technician A".  If it does we have
    # a Tech A/Tech B question and the answers shouldn't be shuffled (randomised)
    shuffle_answers = false if indx.zero? and not answer[:text].downcase.match(/^technician a/).nil?
  end
  
  # Bind the question and answers together in the multichoice table
  multichoice = DB[:cdx_question_multichoice]
  multichoice.insert( :question       => question_id, 
                      :answers        => answer_ids.join(','),
                      :single         => single,
                      :shuffleanswers => shuffle_answers)
  
  question_id
  
end

def create_findthemissingword_question( category_id, name, text, answers )
  
  # Create the questions
  question = DB[:cdx_question]
  question.insert(:category     => category_id,
                  :name         => name,
                  :questiontext => text,
                  :qtype        => 'shortanswer',
                  :stamp        => moodle_stamp,
                  :version      => moodle_stamp)
  
  question_id = (next_autoincrement_id(:cdx_question) - 1)
  
  # Create the answers
  answer_ids = []
  answers.each do |answer|
    answers = DB[:cdx_question_answers]
    answers.insert( :question => question_id,
                    :answer   => answer[:text],
                    :fraction => answer[:result],
                    :feedback => answer[:feedback])
    
    answer_ids << (next_autoincrement_id(:cdx_question_answers) - 1)
  end
  
  # Associate the question and it's answers in the shortanswer table
  # Explicitly flag the answers to be case-insensitive
  shortanswer = DB[:cdx_question_shortanswer]
  shortanswer.insert( :question => question_id,
                      :answers  => answer_ids.join(','),
                      :usecase  => 0)
  
  question_id

end

def create_random_questions( question_category_id, quiz_id, num_questions = 1, questions_per_page = nil )
  
  # Find the category name
  category_name     = DB[:cdx_question_categories][:id => question_category_id][:name]
  new_question_ids  = []
  paged_questions   = []
  
  num_questions.times do 

    # Create the random question
    question = DB[:cdx_question]
    question.insert(:category     => question_category_id,
                    :name         => "Random Question (#{category_name})",
                    :questiontext => '1',
                    :qtype        => 'random',
                    :stamp        => moodle_stamp,
                    :version      => moodle_stamp)
                
    next_id     = next_autoincrement_id(:cdx_question)
    question_id = next_id.to_i - 1
  
    # Update the question's parent with the question ID
    question.filter(:id => question_id).update(:parent => question_id)
  
    # Insert the question into the quiz question instances so it's associated with the quiz
    qqinstance = DB[:cdx_quiz_question_instances]
    qqinstance.insert(:quiz => quiz_id, :question => question_id, :grade => 1)
    
    new_question_ids << question_id
    
  end
  
  # Get the current questions associated with this quiz
  quiz            = DB[:cdx_quiz]
  quiz_questions  = quiz[:id => quiz_id][:questions]
  
  # Add the new questions
  questions = quiz_questions.gsub(',0', '').split(',')
  questions = questions + new_question_ids
  
  if questions_per_page.nil?
    questions << 0
    
  else
    # Insert the page breaks
    questions.each_with_index do |q, i|
      paged_questions << q
      paged_questions << 0 if (i+1).divmod(questions_per_page)[1].eql?(0)
    end
    questions.replace(paged_questions)
    
  end
  
  # Squish the array together into a string
  quiz_questions = questions.join(',')
  
  # Update the quiz with the new question set
  quiz.filter(:id => quiz_id).update(:questions => quiz_questions)
  
end

def next_autoincrement_id( table_name )
  table_name  = table_name.to_s unless table_name.is_a?(String)
  dataset     = DB["SELECT auto_increment FROM information_schema.tables WHERE table_schema='moodle_a620' AND table_name='#{table_name}'"]
  
  dataset.first[:auto_increment]
end

def rand_string( num_chars )
  # Based on: http://stackoverflow.com/questions/88311/how-best-to-generate-a-random-string-in-ruby
  o       =  [('a'..'z'),('A'..'Z'),('0'..'9')].map{|i| i.to_a}.flatten
  string  =  (0..num_chars).map{ o[rand(o.length)]  }.join
end

def moodle_stamp
  sixrandchars  = rand_string(5) # [a-zA-Z0-9]{5}
  timestamp     = Time.now.strftime('%y%m%d%H%M%S') # 080304234653 - yymmddhhmmss
  "a620.moodle.cartman.cdxplus.com+#{timestamp}+#{sixrandchars}"
end

def process_gift( filename )
  puts "=> Processing: #{filename}"

  questions = {}
  name      = ''
  
  File.open(filename, 'r').each("\n") do |line|
    
    if line[0,2].eql?('//') # Comment line
      # next
    
    elsif line[0,2].eql?('::') # Question line
      name            = line.split('::')[1]
      questions[name] = {}
      
      # Extract the question
      questiontext  = (line.split('::')[2]).strip
      questiontext  = questiontext[0,questiontext.length-1] # remove trailing '{'
      questiontext  = questiontext[6,questiontext.length-6] if questiontext[0,6].eql?('[html]') # remove [html]
      questiontext  = questiontext.strip # remove any trailing spaces
      
      # Check to see if the question is formed correctly
      if not ['.', ':', ';', '?', '\'', '!'].include?(questiontext[questiontext.length-1, 1])
        puts "!! [#{name}] Incorrect ending character."
        puts "[#{name}] \"#{questiontext}\""
      elsif questiontext.match(/^[a-zA-Z0-9\ \.\-,:;\/?!'\)\(_"%&\+=#]*$/).nil?
        puts "!! [#{name}] Invalid characters in question."
        puts "!! Question: \"#{questiontext}\""
      end
      
      # Setup up the question in the data-structure
      questions[name][:questiontext]  = questiontext
      questions[name][:answers]       = []
    
    elsif line[0,1].eql?("\t") # Answer line
      
      line      = line[1,line.length-2]         # get rid of the \t and \r
      parts     = line.split('#')               # separate out the answer and feedback
      result    = (parts[0])[0,1]               # extract the correct/incorrect indicators (=/~)
      answer    = (parts[0])[1,parts[0].length] # may or may not contain percentage
      feedback  = parts[1]
      
      answer_details            = {}
      answer_details[:feedback] = feedback || ''
      
      if answer.split('%').length.eql?(3) # percentage
        parts                   = answer.split('%')
        answer_details[:text]   = parts[2]
        answer_details[:result] = ("%0.3f" % (parts[1].to_f/100).to_s) # convert to decimal
        
        # If this is a TGT and we have a percentage then the quiz, question should be multiple
        
      else # true/false
        answer_details[:text]   = answer
        answer_details[:result] = (result.eql?('=') ? 1 : 0)
        
        puts '!! Bad gift' if feedback.nil?
        
      end
      
      questions[name][:answers] << answer_details
      
    elsif line[0,1].eql?('}') # Close of question
      name = ''
      
    end
    
  end
  
  questions
  
end

def find_gift_file( gift_filename, gift_dirs )
  gift_dirs.each{|gdir| return gdir if File.exists?(gdir + gift_filename)}
  nil
end
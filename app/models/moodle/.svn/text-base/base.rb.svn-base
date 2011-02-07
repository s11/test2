# 
#  base.rb
#  online
#  
#  Created by John Meredith on 2008-03-17.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class Moodle::Base < ActiveRecord::Base
  # Ensure this class is abstract
  self.abstract_class = true

  # Make sure we're talking to the correct DB
  establish_connection :cdx_moodle


  acts_as_reportable

  
  # Class variables
  class << self
    # Switches the Moodle models to point to the named database
    def setup_tables_by_database(database_name)
      Moodle::Context.set_table_name        "#{database_name}.cdx_context"
      Moodle::Course.set_table_name         "#{database_name}.cdx_course"
      Moodle::CourseCategory.set_table_name "#{database_name}.cdx_course_categories"
      Moodle::Quiz.set_table_name           "#{database_name}.cdx_quiz"
      Moodle::QuizAttempt.set_table_name    "#{database_name}.cdx_quiz_attempts"
      Moodle::QuizGrade.set_table_name      "#{database_name}.cdx_quiz_grades"
      Moodle::Role.set_table_name           "#{database_name}.cdx_role"
      Moodle::RoleAssignment.set_table_name "#{database_name}.cdx_role_assignments"
      Moodle::User.set_table_name           "#{database_name}.cdx_user"
    end

    # Switches the Moodle models to point to the database associated with the given client
    # Usage: Moodle::Base.setup_tables_by_client
    def setup_tables_by_client(client)
      setup_tables_by_database(client.client_database_name)
    end
    
    #
    # Creates a moodle instance for the given client
    #
    def create_instance(client)
      # Read in the SQL file replacing placeholders with the appropriate values.
      IO.readlines("#{RAILS_ROOT}/db/sql/create_moodle_database.sql").join.gsub(/\n/, '').gsub(/MOODLE_DATABASE_NAME/, client.moodle_database_name).split(';').each do |statement|
        Moodle::Base.connection.execute statement
      end
      logger.info { "[Client] #{client.prefix}: Moodle database '#{client.moodle_database_name}' created" }
    end
  end
end

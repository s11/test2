#--
#  cli.rb
#  management
#  
#  Created by John Meredith on 2009-05-15.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
require 'optparse'
require 'fastercsv'

require 'script/csv2gift/quiz'
require 'script/csv2gift/question'
require 'script/csv2gift/answer'

module Moodle
  module Csv2gift
    class CLI
      def self.execute(stdout, arguments=[])
        options = {
          :heading      => true,
          :output       => nil,
          :overwrite    => false,
          :counter      => 1,
          :title_prefix => "TQ"
        }
        mandatory_options = %w( )

        parser = OptionParser.new do |opts|
          opts.banner = <<-BANNER.gsub(/^ +/, '')
          Parses the given CSV files into the Moodle GIFT format

          Usage: #{File.basename($0)} [OPTIONS]... [FILE]...

          Options are:
          BANNER

          opts.separator '-' * 72

          opts.on("--force", "Force overwriting of the named output file.", "Requires --output.") do
            options[:overwrite] = true
          end

          opts.on("-h", "--help", "Show this help message.") do
            stdout.puts opts
            exit
          end

          opts.on("-o", "--output=FILE", String, "Where to send the generated GIFT data.", "Default: STDOUT") do |arg|
            options[:output] = arg
          end

          opts.on("--omit-heading", "Do not include a heading in the output.") do
            options[:heading] = false
          end

          opts.on("--omit-title", Integer, "Do not generate sequencial question titles.") do |number|
            options[:counter] = nil
          end

          opts.on("--start-count=NUMBER", Integer, "Start the counter from NUMBER.", "Default: 1") do |number|
            options[:counter] = number
          end

          opts.on("--title-prefix=PREFIX", String, "Use the specified PREFIX when generating titles.", "Default: TQ") do |prefix|
            options[:title_prefix] = prefix
          end

          opts.on('--example-csv', "Display an example of the CSV layout required.") do
            puts <<-EXAMPLE.gsub(/^ +/, '')
            Example CSV file layout for correct GIFT generation:
            
            Question,Answer 1,Answer 2,Answer 3,Answer 4,Answer 5,Answer 6,Answer 7,Answer 8,Feedback,Category,Topic Area,Topic Group,Topic
            In the case of a building fire the procedure will involve leaving a building and:,assembling at a mustering point.,staying outside until the all clear is given.,going home until the emergency is over.,closing and locking all doors.,,,,,Ensuring that everyone is accounted for is of primary importance.  Emergency personnel should be informed if someone is not accounted for.,Safety & Information,Occupational Safety & Health,Hazards & emergencies,Evacuating in an emergency
            The first rule in the case of an emergency is:,don't panic,wait for confirmation that it's a real emergency.,"ignore the warning, it's probably a ""drill"".",run outside.,,,,,Panicking usually results in decisions that result in more harm than good.,Safety & Information,Occupational Safety & Health,Hazards & emergencies,Evacuating in an emergency
            ...etc...

            NOTE: The header row (ie. the first row) is required.
            EXAMPLE

            exit
          end

          opts.on("-v", "--version", "Show the version and exit.") do
            stdout.puts "#{File.basename($0)} v#{MoodleTools::VERSION}"
            exit
          end

          opts.parse!(arguments)

          if mandatory_options && mandatory_options.find { |option| options[option.to_sym].nil? }
            stdout.puts opts
            exit
          end

          if arguments.size == 0
            stdout.puts opts
            exit
          end
        end

        result = ""
        arguments.each do |filename|
          i = options[:counter]

          FasterCSV.foreach(filename, :headers => true) do |line|
            question = Moodle::Csv2gift::Question.new(line['Question'])
            question.category    = line['Category']
            question.topic_area  = line['Topic Area']
            question.topic_group = line['Topic Group']
            question.topic       = line['Topic']

            unless i.nil?
              question.title = "%s%04d" % [options[:title_prefix], i]
              i += 1
            end

            feedback = line['Feedback']
            (1..8).each do |answer_number|
              question.answers << Moodle::Csv2gift::Answer.new(line["Answer #{answer_number}"], :comment => feedback, :correct => (answer_number == 1)) unless line["Answer #{answer_number}"].nil?
            end

            result << question.to_gift + "\n\n"
          end

          if options[:heading]
            heading = <<-HEADING.gsub(/^ +/, '')
            //
            // Date generated: #{DateTime.now}
            // From files    : #{arguments.map {|f| File.basename(f) }.join(', ')}
            //
            HEADING
            
            result = heading << result
          end

          # Save the data to the specified file if requested.
          if options[:output]
            file_writer = lambda { File.open(options[:output], "w") { |file| file << result }}

            if File.exists?(options[:output])
              if options[:overwrite]
                file_writer.call
              else
                stdout.puts "File `#{options[:output]}` already exists. Use --force to overwrite."
              end
            else
              file_writer.call
            end
          else
            stdout.puts result
          end
        end
      end
    end
  end
end

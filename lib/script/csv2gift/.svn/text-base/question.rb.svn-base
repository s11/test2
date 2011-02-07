#--
#  question.rb
#  moodle_tools
#  
#  Created by John Meredith on 2009-05-14.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
module Moodle
  module Csv2gift
    class Question
      attr_accessor :question
      attr_accessor :options
      attr_accessor :answers

      attr_accessor :category, :topic_area, :topic_group, :topic

      def initialize(question, options = {},  &block)
        @question = question.to_s.strip

        @options = {
          :title   => nil
        }.merge(options)

        @answers  = []
      end

      def has_title?
        @options.has_key?(:title) && !@options[:title].to_s.empty?
      end

      def title=(value)
        @options[:title] = value
      end

      def to_gift
        result = []
        result << "// #{'-' * 72}"
        result << "//    Category: #{@category}"
        result << "//  Topic Area: #{@topic_area}"
        result << "// Topic Group: #{@topic_group}"
        result << "//       Topic: #{@topic}"
        result << "// #{'-' * 72}"
        result << "#{"::#{@options[:title]}::" if has_title?}#{@question}{"
        result += @answers.map { |a| a.to_gift }
        result << "}"
        result.join("\n")
      end
    end
  end
end
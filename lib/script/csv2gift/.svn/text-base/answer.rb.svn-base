#--
#  answer.rb
#  moodle_tools
#  
#  Created by John Meredith on 2009-05-14.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
module Moodle
  module Csv2gift
    class Answer
      attr_accessor :text

      def initialize(text, options = {})
        @text    = text.to_s.strip
        if ['true', 'false'].include?(@text)
          @text.capitalize!
        end

        @options = {
          :correct => false,
          :comment => nil
        }.merge(options)
      end

      def is_correct?
        @options[:correct]
      end

      def has_comment?
        @options.has_key?(:comment) && @options[:comment] && !@options[:comment].strip.empty?
      end

      def to_gift
        result = []
        result << "  #{is_correct? ? '=' : '~'} #{@text}"
        result << "  # #{@options[:comment]}" if has_comment?
        result.join("\n")
      end
    end
  end
end
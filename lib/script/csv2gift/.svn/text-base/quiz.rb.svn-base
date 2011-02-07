#--
#  quiz.rb
#  moodle_tools
#  
#  Created by John Meredith on 2009-05-14.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
module Moodle
  module Csv2gift
    class Quiz
      attr_accessor :questions

      def to_gift
        result = []
        result << @questions.map { |q| q.to_gift }
        result.join("\n")
      end
    end
  end
end
# 
#  helper.rb
#  administration
#  
#  Created by John Meredith on 2008-11-13.
#  Copyright 2008 CDX Global. All rights reserved.
# 

module NetSuite
  module Filters
    module ClassMethods
      def netsuite_session_filter(options = {})
        around_filter NetSuite, options
      end
    end

    module InstanceMethods
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end

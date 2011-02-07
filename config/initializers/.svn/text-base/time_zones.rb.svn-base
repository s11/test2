# 
#  time_zones.rb
#  online
#  
#  Created by John Meredith on 2009-09-08.
#  Copyright 2009 CDX Global. All rights reserved.
# 
class ActiveSupport::TimeZone
  # Convenience method to cover most zones we cater to outside of the USA & Canada
  NON_US_ZONES = ZONES.find_all { |z| z.tzinfo.name =~ /Australia|London|Dublin|Wellington|Auckland/ }
  
  def self.non_us_zones
    NON_US_ZONES
  end
end
# 
#  trial_signup_helper.rb
#  online
#  
#  Created by John Meredith on 2008-08-20.
#  Copyright 2008 CDX Global. All rights reserved.
# 
module TrialSignupHelper
  #
  # Returns an option list (or optgroup list) of the regions (if any)
  #
  def country_region_option_groups_for_select(country_or_region)
    if country_or_region.is_a?(Country)
      collection = country_or_region.regions.roots.sort {|x, y| x.name <=> y.name}
    elsif country_or_region.is_a?(Region)
      collection = country_or_region.children.sort {|x, y| x.name <=> y.name}
    else
      return []
    end

    collection.inject("") do |output, region|
      if region.leaf?
        output += "<option value='#{region.code}'>#{region.name}</option>"
      else
        output += "<optgroup label=\"#{region.name}\">"
        output += country_region_option_groups_for_select(region)
        output += '</optgroup>'
      end
    end
  end
end

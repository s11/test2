#--
#  sass.rb
#  management
#  
#  Created by John Meredith on 2009-06-22.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
Sass::Plugin.options[:template_location] = RAILS_ROOT + "/app/stylesheets"

if Rails.env.development?
  Sass::Plugin.options[:style] = :expanded
else
  Sass::Plugin.options[:style] = :compressed
end

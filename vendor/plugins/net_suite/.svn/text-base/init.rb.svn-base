# 
#  init.rb
#  administration
#  
#  Created by John Meredith on 2008-11-24.
#  Copyright 2008 CDX Global. All rights reserved.
# 

# This should force Rails to reload the plugin in dev mode
ActiveSupport::Dependencies.load_once_paths.delete(lib_path) unless Rails.configuration.reload_plugins?

# Load the netsuite libs
require "netsuite"
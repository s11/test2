# 
#  ruport.rb
#  management
#  
#  Created by John Meredith on 2009-08-09.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
# 

# We want to be able to wrap report data in a WillPaginate::Collection. Let's monkeypatch it to give access to the data for now 
#
# NOTE: Should probably subclass this
class Ruport::Data::Table
  public
    attr_writer :data
end
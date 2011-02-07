#--
#  print_support_controller.rb
#  management
#  
#  Created by John Meredith on 2009-08-04.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class PrintSupportController < ApplicationController

  def content
    # FIXME: There may be a possible security issue with sending any file on the system if a carefully crafted URL is used. Needs to
    #        be investigated further and file_with_path sanitized.
    file_with_path = "#{RAILS_ROOT}/public/assets/" << params['filename_details'] * '/'

    # We can't use respond_to here as the route globbing doesn't seem to want to split off the format. See 
    # https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/1939 for more details
    case file_with_path
      when /\.html$/
        render :file => file_with_path, :layout => true
      when /\.pdf$/
        send_file(file_with_path, :type => 'application/pdf', :disposition => 'attachment', :x_sendfile => true)
    end
  end

end

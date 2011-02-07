# 
#  trial_signup.rb
#  online
#  
#  Created by John Meredith on 2008-08-27.
#  Copyright 2008 CDX Global. All rights reserved.
# 
class ApplicationMailer < ActionMailer::Base
  def pearson_trial_signup_notification(recipient)
    recipients recipient.email
    subject "Your Pearson trial login details"
    from "donotreply@cartman.cdxglobal.com"
    bcc "johnm@cdxglobal.com"
    body :recipient => recipient
  end
end

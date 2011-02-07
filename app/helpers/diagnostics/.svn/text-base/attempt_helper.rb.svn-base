module Diagnostics::AttemptHelper
  
  def attempt_no(exam, attempt)
    if attempt.verification_id
      (exam.choices.verification.map(&:choice_id).index(attempt.verification_id) + 1).to_s
    elsif attempt.identification_id
      (exam.choices.identification.map(&:choice_id).index(attempt.identification_id) + 1).to_s
    elsif attempt.rectification_id
      (exam.choices.rectification.map(&:choice_id).index(attempt.rectification_id) + 1).to_s
    end
  end
  
  def shorten(message)
    max_length = 30 # chars
    message.length > max_length ? message[0,25] + ' ...' : message
  end
  
  def abbr(classification)
    case classification
    when 'verification':
      'verify'
    when 'identification':
      'identify'
    when 'rectification':
      'rectify'
    end
  end
  
end
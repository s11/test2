class Diagnostics::ExamsController < ApplicationController
  
  def start
    # FIXME - Store this for the scenarios button
    session[:scenario_list] = request.referer
    
    system_name = params[:system_name].gsub('-and-', '-&-').gsub('-', ' ').downcase
    system      = Diagnostics::System.find(:first, :conditions => ['LOWER(name) = ?', system_name])
    logger.debug { "System   : #{system.to_yaml}" }
    
    scenarios   = system.scenarios.sort
    logger.debug { "Scenarios: #{scenarios.to_yaml}" }

    scenario    = scenarios[params[:scenario_num].to_i - 1]
    logger.debug { "Scenario#: #{params[:scenario_num].to_i - 1}" }
    logger.debug { "Scenario : #{scenario.to_yaml}" }
    
    exam = scenario.exams.create!({ :user_id      => current_user.id, 
                                    :commenced_at => Time.zone.now,
                                    :system_id    => scenario.system.id,
                                    :is_practice  => scenario.is_practice })
    
    redirect_to verify_diagnostics_exam_attempts_url(exam.id)
  end
  
end
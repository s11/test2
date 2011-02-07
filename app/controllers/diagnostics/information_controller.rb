class Diagnostics::InformationController < ApplicationController
  
  layout 'popup'
  
  caches_action :verify, :verify_result, :identify, :identify_result, 
                :rectify, :rectify_result
  
  def solution
    @scenario = Diagnostics::Scenario.find(params[:scenario_id])
  end
  
end
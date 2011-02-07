#--
#  terms_and_conditions_acceptances_controller.rb
#  management
#  
#  Created by John Meredith on 2009-08-18.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class TermsAndConditionsAcceptancesController < InheritedResources::Base
  actions :new, :create

  skip_before_filter :require_current_terms_and_conditions_acceptance, :only => [:new, :create]


  def create
    create! do |success, failure|
      success.html do
        redirect_back_or_default root_path
      end
    end
  end


  protected
    # The context is the current user
    def begin_of_association_chain
      current_user
    end

    def build_resource
      @latest_terms_and_conditions      ||= TermsAndConditions.latest(current_user.menu)
      @terms_and_conditions_acceptance  ||= current_user.terms_and_conditions_acceptances.build(:terms_and_conditions => @latest_terms_and_conditions)
    end
end

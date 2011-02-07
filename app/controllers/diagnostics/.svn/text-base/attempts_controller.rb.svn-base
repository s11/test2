class Diagnostics::AttemptsController < ApplicationController
  before_filter :setup
  
  def create
    attempt = @exam.attempts.create!(params['attempt'])
    
    if @exam.completed
      @exam.completed_at  = Time.zone.now
      @exam.final_mark    = @exam.marks_remaining
      @exam.save!
    end
    
    redirect_to diagnostics_exam_attempt_result_url(@exam.id, attempt)
    
  end
  
  def update
    @exam.attempts.create(params['attempt'])
  end
  
  def verify
    @attempt = @exam.attempts.build({:classification => 'verification'})
    @hint    = @exam.scenario.hints.find_by_classification('verification')
    
    render :template => 'diagnostics/attempts/verify'
  end
  
  def identify
    @attempt  = @exam.attempts.build({:classification => 'identification'})
    @hint     = @exam.scenario.hints.find_by_classification('identification')
    
    render :template => 'diagnostics/attempts/identify'
  end
  
  def rectify
    @attempt  = @exam.attempts.build({:classification => 'rectification'})
    @hint     = @exam.scenario.hints.find_by_classification('rectification')
    
    render :template => 'diagnostics/attempts/rectify'
  end
  
  def hint
    @exam.attempts.create(params['attempt'])
    
    case params[:classification]
    when 'verification'
      redirect_to verify_diagnostics_exam_attempts_url(@exam)
    when 'identification'
      redirect_to identify_diagnostics_exam_attempts_url(@exam)
    when 'rectification'
      redirect_to rectify_diagnostics_exam_attempts_url(@exam)
    end
  end
  
  def result
    # TODO: Check whether the student can see the result of this attempt
    
    @attempt  = Diagnostics::Attempt.find(params[:attempt_id])
    @exam     = @attempt.exam
    @scenario = @attempt.exam.scenario
    
    # Determine where the user should go from here
    case @attempt.classification
    when 'verification'
      @return_to_url  = verify_diagnostics_exam_attempts_url(@exam)
      @move_on_url    = identify_diagnostics_exam_attempts_url(@exam)
    when 'identification'
      @return_to_url  = identify_diagnostics_exam_attempts_url(@exam)
      @move_on_url    = rectify_diagnostics_exam_attempts_url(@exam)
    when 'rectification'
      @return_to_url  = rectify_diagnostics_exam_attempts_url(@exam)
      @move_on_url    = nil
    end
  end
  
  private
  
  def setup
    @user     = current_user
    @exam     = Diagnostics::Exam.find(params[:exam_id])
    @system   = @exam.scenario.system
    @scenario = @exam.scenario
  end

end
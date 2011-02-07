#--
#  tasksheet_submissions_controller.rb
#  management
#  
#  Created by John Meredith on 2009-06-28.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class TasksheetSubmissionsController < InheritedResources::Base
  actions :all, :bulk_new, :bulk_create


  # Breadcrumbs
  add_breadcrumb "Tasksheet Management", 'tasksheet_submissions_path(:status => "pending")'


  def create
    tasksheet = Tasksheet.first(:conditions => ["number=?", "C#{params[:tasksheet_number]}"])
    if current_client.is_tasksheet_submission_allowed?(tasksheet.try(:id))
      @tasksheet_submission = build_resource
      @tasksheet_submission.tasksheet = tasksheet
      create! { pending_tasksheet_submissions_path }
    else
      flash[:notice] = "The tasksheet you have selected is outside of the NATEF Task Areas selected for this instance."
      redirect_to new_tasksheet_submission_path
    end
  end

  def pending
    collection
    render :action => :index
  end
  alias_method :approved, :pending
  alias_method :rejected, :pending

  # Copied directly from InheritedResources
  def bulk_new
    @tasksheet_submission = current_client.tasksheet_submissions.new(:completed_on => Date.today)

    if params[:tasksheet_number].present?
      if Tasksheet.exists?(:number => "C#{params[:tasksheet_number]}")
        tasksheet = Tasksheet.first(:conditions => { :number => "C#{params[:tasksheet_number]}" })
        if current_client.is_tasksheet_submission_allowed?(tasksheet.try(:id))
          @tasksheet_submission.tasksheet = tasksheet
        else
          flash[:error] = "The tasksheet you have selected is outside of the NATEF Task Areas selected for this instance."
        end
      else
        flash[:error] = "Unable to find the specified tasksheet. Please try again."
      end
    end

    if params[:class_group_id].present?
      @tasksheet_submission.class_group = current_client.class_groups.find(params[:class_group_id]) 
      @users = @tasksheet_submission.class_group.students
    else
      @users = current_client.students
    end

    if params[:completed_on].present?
      @tasksheet_submission.completed_on = params[:completed_on].to_date

      if @tasksheet_submission.invalid? && @tasksheet_submission.errors.invalid?(:completed_on)
        flash[:error] = "The date the tasksheet was completed must be #{@tasksheet_submission.errors[:completed_on]}" 
        @tasksheet_submission.completed_on = Date.today
      end
    end
  end

  # Allow bulk tasksheet submissions against multiple users
  def bulk_create
    if student_grades = params[:grades]
      tasksheet_id = params[:tasksheet_submission][:tasksheet_id]
      completed_on = params[:tasksheet_submission][:completed_on]
      
      tasksheet_submission = nil
      class_group          = current_client.class_groups.find(params[:tasksheet_submission][:class_group_id])
      class_group.users.students.find_each do |student|
        # Make sure we don't submit a tasksheet at all if "Off" has been selected for that student
        next if student_grades[student.id.to_s].eql?("off")

        tasksheet_submission       = class_group.tasksheet_submissions.find_or_initialize_by_user_id_and_tasksheet_id_and_completed_on(student.id, tasksheet_id, completed_on)
        tasksheet_submission.grade = student_grades[student.id.to_s]
        tasksheet_submission.state = 'approved'
        tasksheet_submission.save
      end
      
      flash[:notice] = "Tasksheet #{tasksheet_submission.tasksheet.number} successfully submitted."
      
      redirect_to :action => :bulk_new
    end
  end

  def bulk_update
    approved = params[:submissions] && params[:submissions].reject { |k,v| v == 'rejected' }.keys
    TasksheetSubmission.update_all("state='approved'", { :id => approved }) if approved.present?

    rejected = params[:submissions] && params[:submissions].reject { |k,v| v == 'approved' }.keys
    TasksheetSubmission.update_all("state='rejected'", { :id => rejected }) if rejected.present?

    redirect_to :back
  end

  protected
    def begin_of_association_chain
      if current_user.role.supervisor?
        current_client
      else
        current_user
      end
    end
    
    def collection
      unless defined?(@search)
        # Nullify unless the dates are valid. NOTE: This seems hacky.
        # if params[:search]
        #   params[:search][:completed_on_or_before_date].to_date rescue params[:search][:completed_on_or_before_date]  = Date.today
        #   params[:search][:completed_on_or_after_date].to_date  rescue params[:search][:completed_on_or_after_date]   = Date.new
        # end
          
        # NOTE: We specify client and optional student id's here as SearchLogic get's itself into a twist with :through associations
        @search = end_of_association_chain.searchlogic(params[:search])

        # @search.user_client_id_equals = current_client.id
        @search.class_group_id_not_null
        @search.user_id_equals = current_user.id if current_user.role.student?

        # The following will always be either :pending, :approved or :rejected
        @search.state_equals = params[:action] if params[:action].present?
      end

      @tasksheet_submissions ||= @search.paginate(:include => [:tasksheet, :user], :page => params[:page], :per_page => params[:per_page])
    end
end

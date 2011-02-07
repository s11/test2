#--
#  reports_controller.rb
#  management
#  
#  Created by John Meredith on 2009-08-05.
#  Copyright 2009 DVP Media Pty Ltd. All rights reserved.
#++
class ReportsController < InheritedResources::Base
  has_scope :by_type, :key => :type


  before_filter :setup_breadcrumbs


  def index
    respond_to do |wants|
      wants.html do
        if params[:owner_ids].present?
          @report_table = build_resource.individual_ruport_table(:sort_by => params[:sort_by], :sort_as => params[:sort_as])
        else
          @report_table = build_resource.paginated_ruport_table(params[:page] || 1, :per_page => params[:per_page], :sort_by => params[:sort_by], :sort_as => params[:sort_as])
        end
      end

      wants.pdf do
        pdf = build_resource.render(:pdf, current_user, :sort_by => params[:sort_by], :sort_as => params[:sort_as])

        # Construct a friendly PDF filename
        filename = (params[:type] == 'assessment' ? params[:assessment_type] : params[:type])
        filename += "_report_#{Time.now.to_s(:timestamp)}.pdf"

        send_data pdf, :filename => filename, :type => "application/pdf", :disposition => "attachment"
      end

      wants.csv do
        csv = build_resource.render(:csv, current_user, :sort_by => params[:sort_by], :sort_as => params[:sort_as])

        # Construct a friendly PDF filename
        filename = (params[:type] == 'assessment' ? params[:assessment_type] : params[:type])
        filename += "_report_#{Time.now.to_s(:timestamp)}.csv"

        send_data csv, :filename => filename, :type => "text/csv", :disposition => "attachment"
      end
    end
  end

  def create
    build_resource
    render :action => "index"
  end


  protected
    def begin_of_association_chain
      return @begin_of_association_chain if defined?(@begin_of_association_chain)

      @begin_of_association_chain = if current_user.role.student?
        current_user
      else
        if params[:owner_ids].present?
          current_client.users.find(params[:owner_ids])
        else
          current_client
        end
      end
    end

    # InheritedResources doesn't correctly use any scopes when building the resource. Do it manually.
    def build_resource
      @report ||= end_of_association_chain && begin_of_association_chain.send("#{current_scopes[:type]}_reports").build(params[:report])

      @report.name = DateTime.now

      # Default to the current menu and version if required
      @report.menu         = current_menu         if @report.menu_id.blank?
      @report.menu_version = current_menu_version if @report.menu_version_id.blank?
      
      # Applicable only to assessment reports
      @report.preferred_assessment_type = params[:assessment_type]  if params[:assessment_type].present?

      @report
    end
    
    # Need to override the default collection to only load the specific saved reports
    def collection
      @search  ||= end_of_association_chain.searchlogic(params[:search])
      @reports ||= @search.paginate(:page => params[:page], :per_page => params[:per_page])
    end


  private
    # Adds our current location to the breadcrumb
    def setup_breadcrumbs
      if params[:assessment_type].present?
        add_breadcrumb "#{params[:assessment_type].titleize} Assessment Report", reports_path(:type => "assessment", :assessment_type => params[:assessment_type])
      else
        add_breadcrumb "#{params[:type].titleize} Report"
      end
    end
end

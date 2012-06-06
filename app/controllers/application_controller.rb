class ApplicationController < ActionController::Base
  protect_from_forgery

  # before_filters
  def check_project_exists
    @project = Project.find_by_id(params[:project_id] || params[:id])
    unless @project
      fail_response "Project does not exists"
    end
  end

  def check_project_active
    unless @project.active
      fail_response "Project '#{@project.name}' has been deleted, recover it in owner's profile"
    end
  end

  # responses
  def fail_response(error=nil)
    @error = error
    respond_to do |format|
      format.html do
        flash[:alert] = @error
        redirect_to root_path
      end
      format.js   {render :layout => false }
      format.json {render :json => {:success => false, :error => @error}}
    end
  end
  
  def success_response(data=nil)
    @data = data
    respond_to do |format|
      format.html {render }
      format.js   {render :layout => false }
      format.json {render :json => {:success => true, :data => @data}}
    end
  end

  def list_response(data=nil, ts)
    @data = data
    @ts = ts
    ts = 0 unless ts
    respond_to do |format|
      format.html {render }
      format.js   {render :layout => false }
      format.json {render :json => {:success => true, :data => @data, :ts => @ts }}
    end
  end
    
end

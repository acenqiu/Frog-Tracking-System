class ProjectsController < ApplicationController

	before_filter :authenticate_user!
	before_filter :check_project_exists, :only => [:show, :edit, :update, :set_cv, :destroy]
	before_filter :check_project_active, :only => [:show, :edit, :update, :set_cv, :destroy]

	def index
		# 今日任务
		project_ids = current_user.relavant_projects.map(&:id)
		@jobs = Job.for_today.for_me(current_user.id).project_in(*project_ids).order('project_id, priority')

		@done_count = 0
		@done_time = 0
		@total_time = 0
		@jobs.each do |job|
			@total_time += job.expected_time
			if job.is_done?
				@done_count += 1
				@done_time += job.expected_time
			end
		end

		# 需要审核
		audit_project_ids = current_user.relavant_projects.where('should_audit=true').map(&:id)
		@audits = Job.audit_period.project_in(*audit_project_ids).order('project_id, priority')
		
		@home = true
	end

	def new
		@project = Project.new
	end

	def create
		@project = current_user.projects.new params[:project]
		if @project.save
			redirect_to @project
		else
			render :new
		end
	end

	def show
		@current_version = @project.current_version
		@jobs = @current_version.jobs.order('priority') if @current_version

		render
	end

	def edit
		# no more
	end

	def update
		if @project.update_attributes params[:project]
			redirect_to @project
		else
			render :edit
		end
	end

	def set_cv
		@version = @project.versions.find_by_id params[:version_id]
		if @version and @project.update_attribute :current_version, @version
			flash[:notice] = "Version '#{@version.version}' has been set as current version"
			redirect_to [@project, @version]
		else
			redirect_to @project
		end
	end

	def destroy
		if @project.update_attribute :active, false
			flash[:notice] = "Project '#{@project.name}' deleted"
			redirect_to root_path
		else
			flash[:alert] = "Failed to delete this project"
			redirect_to @project
		end
	end

end

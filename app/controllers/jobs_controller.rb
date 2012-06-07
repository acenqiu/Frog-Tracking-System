class JobsController < ApplicationController

	before_filter :authenticate_user!
	before_filter :convert_expected_time_to_s, :only => [:create]
	before_filter :check_job_exists, :only => [:show, :update_status, :audit, :destroy]
	before_filter :check_project_exists, :only => [:new]
	before_filter :check_project_active, :only => [:new]

	def new
		@version = @project.versions.find_by_id params[:version_id]
		unless @version
			@version = @project.current_version
		end

		@job = @project.jobs.new
		@job.version = @version
		@job.type = Job::TYPE[params[:type] == 'bug' ? :bug : :feature]
		@job.expected_start_at = Time.now
	end

	def create
		@job = Job.new params[:job]
		@job.user_id = current_user.id
		@job.status = Job::STATUS[:created]
		@job.closed = false
		if @job.save
			redirect_to project_version_path @job.project, @job.version
		else
			@project = @job.project
			render :new
		end
	end

	def show
		@project = @job.project
		@version = @job.version
		@audits  = @job.audits
	end

	def edit
		
	end

	def update
		
	end

	def destroy
		@job.closed = true
		@job.current_user = current_user
		@job.save

		flash[:notice] = 'Job closed'
		redirect_to @job
	end

	def update_status
		if @job.charge != current_user
			flash[:alert] = "You are not the person in charge to this job"
		else
			key = params[:value].to_s.parameterize.underscore.to_sym
			status = Job::STATUS[key]
			if status
				@job.status = status
				if [:postponed, :wontfix, :notrepro, :duplicate, :bydesign].include? key
					@job.closed = true
				end
				@job.reason = params[:reason]
				@job.current_user = current_user

				if @job.save
					flash[:notice] = "Status updated to '#{status}'"
				else
					flash[:alert] = "Failed to update status"
				end
			else
				flash[:alert] = "Status invalid"
			end
		end

		redirect_to @job
	end

	def audit
		key = params[:value].to_s.parameterize.underscore.to_sym
		result = Audit::RESULT[key]
		if result
			audit = @job.audits.find_or_initialize_by_user_id current_user.id
			audit.result = result
			audit.note = params[:reason]
			if audit.save
				flash[:notice] = "Job audited"
			else
				flash[:alert] = "Failed to audit this job"
			end
		else
			flash[:alert] = "Result invalid"
		end

		redirect_to @job
	end

	private

		def convert_expected_time_to_s
			expected_time = ((params[:job][:expected_time] || '0').to_d * 3600).to_i
			expected_time = nil if expected_time == 0
			params[:job][:expected_time] = expected_time
		end

		def check_job_exists
			@job = Job.find_by_id params[:id]
			unless @job
				redirect_to root_path
			end
		end
end

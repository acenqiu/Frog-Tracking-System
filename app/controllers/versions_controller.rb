class VersionsController < ApplicationController

	before_filter :authenticate_user!
	before_filter :check_project_exists
	before_filter :check_project_active
	before_filter :check_version_exists, :only => [:show, :edit, :update, :release]

	def new
		@version = @project.versions.new
	end

	def create
		@version = @project.versions.new params[:version]
		if @version.save
			redirect_to project_path @project, :version_id => @version
		else
			render :new
		end
	end

	def show
		@jobs = @version.jobs.order('priority, expected_start_at')
		@recent_closed = @version.jobs.closed.order('updated_at desc').limit(10)

		@change_log = ''
		unless @version.release_at
			done = @version.jobs.order('priority, expected_start_at').map(&:title) #TODO: 完成了的才显示
			done.length.times do |i|
				@change_log += "#{i+1}. #{done[i]}\n"
			end	
		end

		@job = @project.jobs.new
		@job.version = @version
	end

	def edit
		#do nothing
	end

	def update
		if @version.update_attributes params[:version]
			flash[:notice] = 'Version Updated'
			redirect_to [@project, @version]
		else
			render :edit
		end
	end

	def release
		@version.release_note = params[:release_note]
		@version.release_at = Time.now
		if @version.save
			flash[:notice] = "Congratulations~ Version '#{@version.version}' released"
		else
			flash[:alert] = "Failed to release this version"
		end

		redirect_to project_version_path(@project, @version)
	end

	private

		def check_version_exists
			@version = @project.versions.find_by_id params[:id]
			unless @version
				redirect_to @project
			end
		end

end

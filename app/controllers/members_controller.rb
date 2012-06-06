class MembersController < ApplicationController

	before_filter :authenticate_user!
	before_filter :check_project_exists
	before_filter :check_project_active
	before_filter :check_member_exists, :only => [:update, :destroy]

	def index
		@members = @project.members
		@member = @project.members.new
	end

	def create
		@member = @project.members.create params[:member]
		if @member.save
			flash[:notice] = "User '#{@member.user.username}' has been added"
		else
			flash[:alert] = "Failed to add user"
		end
		redirect_to project_members_path @project
	end

	def update
		params[:member].delete :user_id
		if @member.update_attributes params[:member]
			flash[:notice] = "Member #{@member.user.username} updated"
		else
			flash[:alert] = 'Failed to update member'
		end

		redirect_to project_members_path @project
	end

	def destroy
		if @member.delete
			flash[:notice] = "Member '#{@member.user.username}' has been removed"
		else
			flash[:alert] = 'Failed to remove this member'
		end
		redirect_to project_members_path @project
	end

	private

		def check_member_exists
			@member = @project.members.find_by_id params[:id]
			unless @member
				flash[:alert] = 'Member Not Found'
				redirect_to project_members_path @project
			end
		end

end

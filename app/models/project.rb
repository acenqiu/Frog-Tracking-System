class Project < ActiveRecord::Base

	attr_accessible :name, :description

	belongs_to :user

	has_many   :members
	has_many   :versions, :order => 'id desc'
	has_many   :jobs

	belongs_to :current_version, :class_name => 'Version'

	after_create :add_to_member

	validates :name, :uniqueness => {:case_sensitive => false}

	def is_admin?(user)
		self.members.find_by_user_id_and_role user.id, Member::ROLE[:admin]
	end

	def get_members_for_select
		list = {}
		array = self.members.joins(:user).select('users.id, users.username')
		array.each { |item| list.merge! item[:username] => item[:id] }
		list
	end

	def get_non_members_for_select
		list = {}
		array = User.no_member(self.id).select('users.id, users.username')
		array.each { |item| list.merge! item[:username] => item[:id] }
		list
	end

	def get_versions_for_select
		list = {}
		versions.each { |item| list.merge! item[:version] => item[:id] }
		list
	end

	private 

		def add_to_member
			members.create :user_id => user_id, :role => Member::ROLE[:admin], :position => 'PM'
		end
end

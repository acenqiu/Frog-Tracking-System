class Version < ActiveRecord::Base

	attr_accessible :version, :description, :start_at, :end_at

	belongs_to :project
	has_many   :jobs

	validates  :version,  :presence => true,
	                      :length   => { :within => 1..40 }

	after_create :update_current_version

	private

		def update_current_version
			self.project.update_attribute :current_version_id, self.id
		end

end

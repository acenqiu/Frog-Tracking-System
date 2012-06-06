class ChangeLog < ActiveRecord::Base

	attr_accessible :user_id, :what, :from, :to, :reason

	belongs_to :job
	belongs_to :user

	validates :what, :presence => true

	def get_description
		if what != 'closed'
			reason_desc = " because #{reason}" unless reason.blank?
			"#{what} changed from #{from} to <span>#{to}</span> by <i>#{user.username}</i> at <i>#{created_at.to_s(:date)}</i>#{reason_desc}"	
		else
			"Closed by <i>#{user.username}</i> at <i>#{created_at.to_s(:date)}</i>"
		end
	end

end

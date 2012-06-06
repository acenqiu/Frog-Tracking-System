class Member < ActiveRecord::Base

	attr_accessible :user_id, :role, :position, :should_audit

	belongs_to :project
	belongs_to :user

	scope :should_audit, :conditions => {:should_audit => true}

	ROLE = {:admin => 'admin', :member => 'member'}
	ROLE_ENUM = {'Admin' => 'admin', 'Member' => 'member'}
end

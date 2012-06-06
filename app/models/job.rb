class Job < ActiveRecord::Base

	attr_accessible :project_id, :user_id, :charge_id, :title, :expected_time, :expected_start_at, :description,
					:type, :version_id, :priority, :tag_list

	acts_as_taggable
	
	belongs_to :project
	belongs_to :user
	belongs_to :charge, :class_name => "User"
	belongs_to :version
	has_many   :change_logs, :order => 'id desc'
	has_many   :audits

	validates  :title,  :presence => true
	validates  :expected_time, :numericality => { :allow_nil => true, :greater_than => 0}
	validates  :priority, :numericality => { :greater_than => 0, :less_than => 6}

	after_create :add_audits
	after_update :create_change_log
	after_update :clear_audits

	scope :closed,       :conditions => {:closed => true}
	scope :audit_period, :conditions => "closed=false and status in ('finished', 'fixed')"
	scope :for_today,  lambda { |*args| {:conditions => ['(expected_start_at>=? and expected_start_at<?) or (expected_start_at<? and closed=?)',
																												Time.now.midnight, Time.now.midnight+1.day, Time.now.midnight, false] }}
	scope :for_me,     lambda { |*args| {:conditions => ['charge_id=?', args.first]} }
	scope :project_in, lambda { |*args| {:conditions => ["project_id in (?)", args] }} 

	set_inheritance_column do
    original_inheritance_column + "_id"
  end

  def current_user=(current_user)
  	@current_user = current_user
  end

  def current_user
  	@current_user
  end

  def reason=(reason)
  	@reason = reason
  end

  def reason
  	@reason
  end

	def type_desc
		is_feature? ? 'Feature' : 'Bug'
	end

	def status_desc
		if closed
			"#{status} & Closed"
		elsif audit_period?
			"#{status} & Audit"
		else
			status
		end
	end

	def is_feature?
		type == TYPE[:feature]
	end

	def is_bug?
		type == TYPE[:bug]
	end

	def delay_at
		days = (expected_time / (3600.0*10)).ceil + 1
		expected_start_at.midnight + days.day
	end

	def is_delayed?
		return false if closed

		if status == STATUS[:ongoing]
			Time.now >= delay_at
		elsif status == STATUS[:created]
			Time.now > (expected_start_at.midnight + 1.day)
		else 
			false
		end
	end

	def audit_period?
		!closed && (%w[finished fixed].include? status)
	end

	def is_done?
		closed || audit_period?
	end

	def is_ongoing?
		status == STATUS[:ongoing]
	end


	TYPE = {:feature => 'feature', :bug => 'bug'}
	TYPE_ENUM = {"Feature" => 'feature', "Bug" => 'bug'}
	STATUS = {:created => 'created', :ongoing => 'ongoing', :finished => 'finished', :fixed => 'fixed', :wontfix => "won't fix", 
						:postponed => 'postponed', :notrepro => 'not repro', :duplicate => 'duplicate', :bydesign => 'by design', :rejected => 'rejected'}

	private

		def add_audits
			project.members.should_audit.each do |member|
				self.audits.create :user_id => member.user_id, :result => Audit::RESULT[:none]
			end
		end

		def create_change_log
			if status_changed?
				change_logs.create :user_id => current_user.id, :what => 'status', :from => status_change[0], :to => status_change[1], :reason => reason
			end

			if closed_changed?
				change_logs.create :user_id => current_user.id, :what => 'closed', :from => false, :to => 'true'
			end
		end

		def clear_audits
			if status_changed? && (status == STATUS[:fixed] || status == STATUS[:finished])
				audits.update_all ['result=?', Audit::RESULT[:none]]
			end
		end

end

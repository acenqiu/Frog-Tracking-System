module JobsHelper

	def audit_label_class(audit)
		if audit.is_pass?
			'label-success'
		elsif audit.is_fail?
			'label-important'
		else
			''
		end
	end

	def get_status_hash(job)
		if job.is_feature?
			array = [:ongoing, :postponed]
			array << :finished if job.is_ongoing?
		else
			array = [:wontfix, :notrepro, :duplicate, :bydesign, :ongoing]
			array << :fixed if job.is_ongoing?
		end

		hash = {}
		array.each do |key|
			value = Job::STATUS[key]
			hash[key] = value unless job.status == value
		end
		hash
	end

	def i_can_audit?(job)
		member = job.project.members.find_by_user_id current_user.id
		member && member.should_audit
	end

	def i_can_close?(job)
		job.user == current_user || job.project.is_admin?(current_user)
	end

end

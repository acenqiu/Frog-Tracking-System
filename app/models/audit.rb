class Audit < ActiveRecord::Base

	attr_accessible :user_id, :result, :note

	belongs_to :job
	belongs_to :user

	after_save :update_job_status

	def is_pass?
		result == RESULT[:pass]
	end

	def is_fail?
		result == RESULT[:fail]
	end

	RESULT = {:pass => 'PASS', :fail => 'FAIL', :none => 'NONE'}

	private 

		def update_job_status
			has_fail = false
			job.audits.each do |audit|
				if audit.result == RESULT[:none]
					return;
				elsif audit.result == RESULT[:fail]
					has_fail = true
				end
			end

			if has_fail
				job.status = Job::STATUS[:rejected]
				job.current_user = user
				job.save

				job.audits.update_all ['result=?', RESULT[:none]], ['result=?', RESULT[:pass]]
			else
				job.closed = true
				job.current_user = user
				job.save
			end
		end
end

module VersionsHelper

	def prettify_time(time)
		if time
			time.to_s :full_date
		else
			''
		end
	end
end

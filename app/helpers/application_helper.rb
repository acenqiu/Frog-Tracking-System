module ApplicationHelper

	def shorten(str, max_len = 25)
    str.length > max_len ? str[0..(max_len | 0x1)] + "..." : str
  end

  def prettify_time(time)
		if time
			time.to_s :full_date
		else
			''
		end
	end

end

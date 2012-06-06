module MembersHelper

	def members_to_json(members)
		array = []
		fields = %w[id role position should_audit]
		if members && members.length > 0
			members.each do |member|
				array << (member.attributes.select { |k| fields.include? k}).to_json unless member.new_record?
			end
		end

		"[#{array.join(',')}]"
	end

end

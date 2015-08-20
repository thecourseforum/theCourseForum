class Schedule < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :sections

	def gpa
		sections.map do |section|
			Stat.find_by(:course => section.course, :professor => section.professors.first).gpa
		end.compact.instance_eval { sum / size.to_f }
	end
end

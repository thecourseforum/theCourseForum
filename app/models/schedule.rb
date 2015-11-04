class Schedule < ActiveRecord::Base
	belongs_to :user
	has_and_belongs_to_many :sections

	def gpa
		Schedule.gpa(sections)
	end

	def self.gpa(sections)
		if sections.first.class != Section
			sections = Section.includes(:professors, {:course => :stats}).find(sections.map do |hash|
				hash[:section_id]
			end)
		end
		sections.map do |section|
			section.course.stats.find_by(:professor => section.professors.first).gpa
		end.compact.instance_eval { sum / size.to_f }
	end
end

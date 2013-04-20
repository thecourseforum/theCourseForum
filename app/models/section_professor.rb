class SectionProfessor < ActiveRecord::Base
  belongs_to :section
  belongs_to :professor
  # attr_accessible :title, :body
end

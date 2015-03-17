class SectionProfessor < ActiveRecord::Base
  belongs_to :section
  belongs_to :professor

end

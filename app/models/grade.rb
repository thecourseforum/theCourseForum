class Grade < ActiveRecord::Base
  belongs_to :section
  belongs_to :semester
end

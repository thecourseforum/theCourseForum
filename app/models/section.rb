class Section < ActiveRecord::Base
  attr_accessible :course_id, :professor_id, :rate_difficulty, :rate_fun, :rate_overall, :rate_professor, :rate_recommend
end

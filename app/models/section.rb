# == Schema Information
#
# Table name: sections
#
#  id              :integer          not null, primary key
#  course_id       :integer
#  professor_id    :integer
#  rate_overall    :float
#  rate_professor  :float
#  rate_fun        :float
#  rate_difficulty :float
#  rate_recommend  :float
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Section < ActiveRecord::Base
  attr_accessible :course_id, :professor_id, :rate_difficulty, :rate_fun, :rate_overall, :rate_professor, :rate_recommend
  belongs_to :course
  belongs_to :professor
end

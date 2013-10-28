class CourseProfessor < ActiveRecord::Base
  belongs_to :course
  belongs_to :professor
  has_many :grades
  has_many :reviews

  def professor_rating
    
  end

  def fun_rating

  end

  def difficulty_rating

  end

  def recommend_rating

  end

end

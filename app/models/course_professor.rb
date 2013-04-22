class CourseProfessor < ActiveRecord::Base
  belongs_to :course
  belongs_to :professor
  has_many :grades
  has_many :reviews
  # attr_accessible :title, :body

  def professor_rating
    
  end

  def fun_rating

  end

  def difficulty_rating

  end

  def recommend_rating

  end

end

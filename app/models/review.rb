class Review < ActiveRecord::Base
  attr_accessible :post_date, :rate_difficulty, 
  					:rate_fun, :rate_overall, :rate_professor, :rate_recommend, :section_id, :user_id, :content
end

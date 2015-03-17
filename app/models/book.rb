class Book < ActiveRecord::Base
	has_many :courses, :through => :book_requirements
	has_many :book_requirements
	

end
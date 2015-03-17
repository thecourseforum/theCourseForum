class BookRequirement < ActiveRecord::Base
	belongs_to :section
	belongs_to :book


end
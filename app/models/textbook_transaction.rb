class TextbookTransaction < ActiveRecord::Base
	belongs_to :seller, :class_name => 'User', :foreign_key => 'seller_id'
	belongs_to :buyer, :class_name => 'User', :foreign_key => 'buyer_id'

	belongs_to :section

	def self.active
		TextbookTransaction.where(:active => true)
	end
end
class TextbookTransaction < ActiveRecord::Base
	default_scope { order('created_at DESC') }

	belongs_to :seller, :class_name => 'User', :foreign_key => 'seller_id'
	belongs_to :buyer, :class_name => 'User', :foreign_key => 'buyer_id'

	belongs_to :book

	validates_presence_of :price, :condition, :book_id

	def self.active
		TextbookTransaction.includes(book: {sections: :course}).where("created_at > ?",(Time.now - 3.days)).where.not("seller_id is not null and buyer_id is not null")
	end
end
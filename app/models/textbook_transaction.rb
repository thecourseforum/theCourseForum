class TextbookTransaction < ActiveRecord::Base

	belongs_to :seller, :class_name => User
	belongs_to :buyer, :class_name => User

	belongs_to :book

	validates_presence_of :seller_id, :price, :condition, :book_id

	def self.active
		TextbookTransaction.where("created_at > ?",(Time.now - 3.days)).where("buyer_id IS NULL")
	end

	def active?
		self.updated_at > (Time.now - 3.days) and not self.buyer_id
	end
end
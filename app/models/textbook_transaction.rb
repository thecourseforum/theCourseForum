class TextbookTransaction < ActiveRecord::Base

	belongs_to :seller, :class_name => User
	belongs_to :buyer, :class_name => User

	belongs_to :book

	validates_presence_of :seller_id, :price, :condition, :book_id

	def self.active
		TextbookTransaction.where("textbook_transactions.updated_at > ? AND textbook_transactions.buyer_id IS NULL", (Time.now - TextbookTransaction.duration))
	end

	def self.duration
		3.days
	end

	def active?
		updated_at > (Time.now - TextbookTransaction.duration) and not buyer_id
	end
end
class TextbookTransaction < ActiveRecord::Base

	belongs_to :seller, :class_name => User
	belongs_to :buyer, :class_name => User

	belongs_to :book

	validates_presence_of :seller_id, :price, :condition, :book_id

	def self.active
		TextbookTransaction.where("textbook_transactions.updated_at > ? AND textbook_transactions.buyer_id IS NULL", (Time.now - TextbookTransaction.duration))
	end

	def self.duration
		14.days
	end

	def active?
		updated_at > (Time.now - TextbookTransaction.duration) and not buyer_id
	end

	def self.as_json(where_clause)
		raw = TextbookTransaction.active.
	      includes(:book => {:sections => {:course => :subdepartment}}).
	      group("textbook_transactions.id").
	      where(where_clause).
	      order('textbook_transactions.updated_at DESC').
	      pluck(
	        :id,
	        :price,
	        'GROUP_CONCAT(DISTINCT CONCAT_WS(" ", mnemonic, course_number) SEPARATOR ", ")',
	        :book_id,
	        "books.title",
	        :medium_image_link,
	        :author,
	        :condition,
	        :notes,
	        "textbook_transactions.updated_at"
	      )

	    # Format into json style
	    raw.map do |textbook_transaction|
			{
			:id => textbook_transaction[0],
			:price => "$" + textbook_transaction[1].to_s,
			:courses => textbook_transaction[2],
			:link => "/books/#{textbook_transaction[3].to_s}",
			:book_id => textbook_transaction[3],
			:title => textbook_transaction[4].tr('*', ''),
			:book_image => textbook_transaction[5] ? textbook_transaction[5] : Book.no_image_link,
			:author => textbook_transaction[6],
			:condition => textbook_transaction[7],
			:notes => textbook_transaction[8] ? textbook_transaction[8] : "none",
			:end_date => (textbook_transaction[9] + TextbookTransaction.duration).localtime.strftime("%b %d, %I:%M %p")
			}
		end
	end

end

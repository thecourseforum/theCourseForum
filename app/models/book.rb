class Book < ActiveRecord::Base
	has_many :sections, :through => :book_requirements
	has_many :book_requirements

	def bookstore_prices
		prices = []
		prices << {
			:condition => 'New',
			:price => bookstore_new_price
		} if bookstore_new_price
		prices << {
			:condition => 'Used',
			:price => bookstore_used_price
		} if bookstore_used_price
		prices
	end

	def amazon_merchant_prices
		prices = []
		prices << {
			:condition => 'New',
			:price => amazon_merchant_new_price
		} if amazon_merchant_new_price
		prices << {
			:condition => 'Used',
			:price => amazon_merchant_used_price
		} if amazon_merchant_used_price
		prices
	end

	def amazon_official_prices
		prices = []
		prices << {
			:condition => 'New',
			:price => amazon_official_new_price
		} if amazon_official_new_price
		prices << {
			:condition => 'Used',
			:price => amazon_official_used_price
		} if amazon_official_used_price
		prices
	end
end
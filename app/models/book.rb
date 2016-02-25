class Book < ActiveRecord::Base
	has_many :sections, :through => :book_requirements
	has_many :book_requirements

	has_many :textbook_transactions, :dependent => :destroy
	has_many :active_listings, -> { where updated_at: (Time.now - TextbookTransaction.duration)..Time.now, buyer_id: nil }, :class_name => TextbookTransaction

	has_and_belongs_to_many :users

	def self.no_image_link
		"/assets/icons/no_book.png"
	end

	def format
		{
			:book => self,
			:image => (self.large_image_link ? self.large_image_link : Book.no_image_link),
			:link => (self.amazon_affiliate_link ? self.amazon_affiliate_link : "#"),
			:new_bookstore => (self.bookstore_new_price ? "$" + sprintf('%.2f', self.bookstore_new_price) : "N/A"),
			:used_bookstore => (self.bookstore_used_price ? "$" + sprintf('%.2f', self.bookstore_used_price) : "N/A"),
			:new_official_amazon => (self.amazon_official_new_price ? "$" + sprintf('%.2f', self.amazon_official_new_price) : "N/A"),
			:used_official_amazon => (self.amazon_official_used_price ? "$" + sprintf('%.2f', self.amazon_official_used_price) : "N/A"),
			:new_merchant_amazon => (self.amazon_merchant_new_price ? "$" + sprintf('%.2f', self.amazon_merchant_new_price) : "N/A"),
			:used_merchant_amazon => (self.amazon_merchant_used_price ? "$" + sprintf('%.2f', self.amazon_merchant_used_price) : "N/A")
		}
	end

	def self.cache_key
		# Number of book-user relations (i.e. followers)
		follow_count = ActiveRecord::Base.connection.execute("select count(*) from books_users").first.first
		# Last updated time for books table
		books_updated_at = Book.maximum(:updated_at)
		# Return key
		"%d%s" % [follow_count, books_updated_at]
	end

	def self.get_all
		# clear cache if query is invalidated to avoid using too much mem, perhaps unnecessary
		unless Rails.cache.exist?("books/#{cache_key}")
			Rails.cache.clear
		end
		# Cache this query, it takes long time
		Rails.cache.fetch("books/#{cache_key}") do 
			# use references(:users) to make activerecord happy
			raw = Book.includes(:users, :sections => {:course => :subdepartment}).
				group("books.id").
				order("follower_count DESC, RAND()").
				pluck(
					:id,
					:title,
					:medium_image_link,
					'GROUP_CONCAT(DISTINCT CONCAT_WS(" ", mnemonic, course_number) SEPARATOR ", ")',
					'COUNT(DISTINCT users.id) AS follower_count'
				)

			# Format into json
			raw.map do |book|
				{
					:id => book[0],
					:title => book[1].tr('*', ''),
					:medium_image_link => book[2],
					:mnemonic_numbers => book[3],
					:follower_count => book[4]
				}
			end
		end
	end


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
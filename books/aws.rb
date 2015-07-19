ActiveRecord::Base.logger.level = 1

log = File.open("#{Rails.root.to_s}/books/aws_#{Time.now.strftime("%Y.%m.%d-%H:%M")}.log", 'w')

config = {}

File.open("#{Rails.root.to_s}/books/aws_secret").each do |line|
	symbol, content = *line.split(';')
	config[symbol.to_sym] = content.chomp
end

client = Vacuum.new

client.configure(
	:aws_access_key_id => config[:key],
	:aws_secret_access_key => config[:secret],
	:associate_tag => config[:associate_tag]
)

books = Book.where.not(:isbn => nil).where(:asin => nil)

puts "How many books? #{books.count} total"
limit = gets.chomp.to_i
# puts "Starting from? (0 indexed)"
# offset = gets.chomp.to_i

books = books[0..limit].each_slice(2)

books.each_with_index do |batch, index|
	puts "Performing #{index + 1} query out of #{books.count}"

	query = {
	    'ItemLookup.Shared.SearchIndex'   => 'All',
	    'ItemLookup.Shared.IdType'        => 'ISBN',
	    'ItemLookup.Shared.ResponseGroup' => 'OfferSummary,Images,ItemAttributes,Offers'
	}

	flag = false
	batch.each_with_index do |book, index|
		query["ItemLookup.#{index + 1}.ItemId"] = book.isbn
		if book.isbn == "9780077501808"
			flag = true
		end
	end

	items = nil

	until items
		begin
			items = client.item_lookup(:query => query).to_h["ItemLookupResponse"]["Items"]
		rescue Exception => e
			puts "Retrying #{index + 1} query"
			puts e
			items = nil
			# Prevent 503 errors
			sleep(0.5)
		end
	end

	puts "Successfully returned response"

	if items.class == Hash
		items = [items]
	end

	items.each do |item|
		if item["Request"]["Errors"]
			log.puts "Could not analyze either #{batch.map(&:title).join(', ')}"
			next
		end

		isbn = item["Request"]["ItemLookupRequest"]["ItemId"]

		book = Book.find_by(:isbn => isbn)

		unless book
			log.puts "Couldn't find book with ISBN: #{isbn}"
			next
		end

		content = item["Item"]
		if item["Item"].class == Array
			content = item["Item"].first
		end

		asin = content["ASIN"]

		link = content["DetailPageURL"]

		small_image = content["SmallImage"] ? content["SmallImage"]["URL"] : nil
		medium_image = content["MediumImage"] ? content["MediumImage"]["URL"] : nil
		large_image = content["LargeImage"] ? content["LargeImage"]["URL"] : nil


		total_new = nil
		total_used = nil
		
		official_new_price = nil
		official_used_price = nil
		merchant_new_price = nil
		merchant_used_price = nil

		if content["OfferSummary"]
			summary = content["OfferSummary"]
			total_new = summary["TotalNew"]
			total_used = summary["TotalUsed"]
			merchant_new_price = summary["LowestNewPrice"]["Amount"].to_f / 100 if summary["LowestNewPrice"]
			merchant_used_price = summary["LowestUsedPrice"]["Amount"].to_f / 100 if summary["LowestUsedPrice"]
		end

		if content["Offers"] and content["Offers"]["TotalOffers"].to_i > 0
			offers = content["Offers"]["Offer"]

			if offers.class == Hash
				offers = [offers]
			end

			new_offer = nil
			offers.each do |offer|
				if offer["OfferAttributes"]["Condition"] == 'New'
					new_offer = offer
					break
				end
			end

			if new_offer
				official_new_price = new_offer["OfferListing"]["Price"]["Amount"].to_f / 100
				# puts "#{official_new_price} #{book.id}"
			end
		end

		# log.puts "#{book.title} vs #{content['ItemAttributes']['Title']}"

		book.update(
			:asin => asin,
			:small_image_link => small_image,
			:medium_image_link => medium_image,
			:large_image_link => large_image,
			:amazon_official_new_price => official_new_price,
			:amazon_official_used_price => official_used_price,
			:amazon_merchant_new_price => merchant_new_price,
			:amazon_merchant_used_price => merchant_used_price,
			:amazon_new_total => total_new,
			:amazon_used_total => total_used,
			:amazon_affiliate_link => link
		)
	end

	# Prevent 503 errors
	# Throttling is based on requests per second
	# 	Current limit is 1 per-second
	sleep(0.5)
end

log.close
# Author Law

# Generate a ton of fake listings

books = Book.order("RAND()")
users = User.order("RAND()")


bc = Book.count
uc = User.count

# Completed transactions
100.times do
	@book = books[rand(bc)]
	@seller = users[rand(uc)]
	@buyer = users[rand(uc)]
	@price = 20 + rand(80)
	@condition = %w(New Good Worn Usable)[rand(3)]

	TextbookTransaction.create(:seller_id => @seller.id, :buyer_id => @buyer.id, :book_id => @book.id, :price => @price, :condition => @condition, :sold_at => Time.now)
end

# Active listings
500.times do
	@book = books[rand(bc)]
	@seller = users[rand(uc)]
	@price = 20 + rand(80)
	@condition = %w(New Good Worn Usable)[rand(3)]

	TextbookTransaction.create(:seller_id => 24218, :book_id => @book.id, :price => @price, :condition => @condition, :sold_at => Time.now)
end	
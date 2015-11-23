class TextbookMailer < ActionMailer::Base
  default from: "support@thecourseforum.com"

  def notify_of_post(arguments = {})
    @listing = arguments[:transaction]
  
    emails = arguments[:emails]

    book_title = @listing.book.title
    price = @listing.price

    mail(bcc: emails, subject: "New Listing: #{book_title} ($#{price})")
  end

  def notify_of_claim(arguments = {})
    @seller = arguments[:seller]
    @buyer_contact = arguments[:buyer_contact]
    
    transaction = arguments[:transaction]
    
    email = @seller.email
    book_title = transaction.book.title
    price = transaction.price

    mail(to: email, subject: "Posting Claimed: #{book_title} ($#{price})")
  end

end

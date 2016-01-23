class TextbookTransactionsController < ApplicationController

  def index
    @count = TextbookTransaction.active.count
  end

  def listings
    where_clause = params[:book_id] ? {:book_id => params[:book_id]} : {}

    @textbook_transactions = TextbookTransaction.as_json(where_clause)
    
    render :json => @textbook_transactions
  end

  def books
    if request.format.to_s.include?('json')
      @books = Book.as_json
    end

    respond_to do |format|
      format.html
      format.json { render :json => @books }
    end
  end

  def claim
    cell = params[:cellphone].strip
    current_user.update(:cellphone => cell)
    transaction = TextbookTransaction.find(params[:claim_id])
    buyer_contact = (current_user.cellphone ? current_user.cellphone : current_user.email)
    body = "\"#{transaction.book.title}\" ($#{transaction.price})\nhas been claimed!\nBuyer's Contact info: #{buyer_contact}"
    
    if cell.length == 10
      if transaction.active?

        begin
          @client = Twilio::REST::Client.new
          @client.account.messages.create(
              :from => '+12406247038',
              :to => transaction.seller.cellphone,
              :body => body
          )
        rescue ArgumentError, Twilio::REST::RequestError => e
          error = e.message
          # If texting doesn't work, use email to notify seller
          TextbookMailer.notify_of_claim(
            :seller => transaction.seller,
            :buyer_contact => buyer_contact,
            :transaction => transaction
          ).deliver_now
        end

        transaction.update(:buyer_id => current_user.id)
        transaction.update(:sold_at => Time.now)

        render status: 202, :json => {}
      else
        render status: 410, :json => {
          message: "Sorry! Already Claimed"
        }
      end
    else
      render status: 400, :json => {
        message: "Bad phone number"
      }
    end
  end


  def create
    book = Book.find(params[:book_id])
    emails = book.users.pluck(:email)

    current_user.update(:cellphone => params[:cellphone])

    if params[:cellphone].length == 10
      params[:seller_id] = current_user.id
      
      @textbook_transaction = TextbookTransaction.new(textbook_transaction_params)
      if @textbook_transaction.save
        
        # Notify followers of the book that has been claimed
        if emails.size > 0
          TextbookMailer.notify_of_post(:emails => emails, :transaction => @textbook_transaction).deliver
        end
        
        render status: 201, :json => {}
      else 
        render status: 400, :json => {
          message: "Missing values"
        }
      end
    else
      render status: 400, :json => {
        message: "Badly formatted phone number"
      }
    end
    
  end

  def show
    @count = 0
    @listings_by_type = {
      active: current_user.active_listings,
      inactive: current_user.inactive_listings,
      sold: current_user.sold_listings
    }
    @theaders = {
      active: ["Price", "Title", "Condition", "Expire Date", "Remove"],
      inactive: ["Price", "Title", "Condition", "Expired Date", "Renew"],
      sold: ["Price", "Title", "Condition", "Sold Date", "Report"]
    }
    @date = {
      active: :updated_at,
      inactive: :updated_at,
      sold: :sold_at
    }
    @date_action = {
      active: ["+", TextbookTransaction.duration],
      inactive: ["+", TextbookTransaction.duration],
      sold: [:to_datetime]
    }
    @glyphicon_classes = {
      active: "glyphicon glyphicon-remove",
      inactive: "glyphicon glyphicon-repeat",
      sold: "glyphicon glyphicon-flag"
    }
    @actions = {
      active: "withdraw",
      inactive: "renew",
      sold: "report"
    }
    @listings_by_type.each_value do |listings|
      @count += listings.count
    end

    @claimed = current_user.claims
    @followed = current_user.books

  end

  def withdraw
    @listing = TextbookTransaction.find(params[:listing_id])
    @listing.update(:updated_at => Time.now - TextbookTransaction.duration - 5.seconds)

    render head: 200, :json => {}
  end

  def renew
    @listing = TextbookTransaction.find(params[:listing_id])
    @listing.update(:updated_at => Time.now)

    render head: 200, :json => {}
  end

  def report
    @listing = TextbookTransaction.find(params[:listing_id])

    #TODO possibilities: mailer, reported column in table, generate bug, etc.
    # handled in javascript for now
    
    render head: 200, :json => {}
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def textbook_transaction_params
      params[:textbook_transaction] = {
        :book_id => params[:book_id],
        :price => params[:price].to_i,
        :condition => params[:condition],
        :notes => (not params[:notes].strip.empty?) ? params[:notes] : nil,
        :seller_id => params[:seller_id]
      }
      params.require(:textbook_transaction).permit(:book_id, :cellphone, :price, :condition, :notes, :seller_id)
    end
    
end
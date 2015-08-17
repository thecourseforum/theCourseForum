class TextbookTransactionsController < ApplicationController

  def index
    @count = TextbookTransaction.active.count
  end

  def listings
    where_clause = params[:book_id] ? {:book_id => params[:book_id]} : {}

    @textbook_transactions = TextbookTransaction.active.
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
    @textbook_transactions = @textbook_transactions.map do |textbook_transaction|
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
    
    render :json => @textbook_transactions
  end

  def books
    if request.format.to_s.include?('json')
      # use references(:users) to make activerecord happy
      @books = Book.includes(:users, :sections => {:course => :subdepartment}).
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
      @books = @books.map do |book|
        {
          :id => book[0],
          :title => book[1].tr('*', ''),
          :medium_image_link => book[2],
          :mnemonic_numbers => book[3],
          :follower_count => book[4]
        }
      end

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
        response = RestClient.post(
          'http://textbelt.com/text', 
          :number => transaction.seller.cellphone, 
          :message => body
        )

        if JSON.parse(response)["success"]
        else 
          TextbookMailer.notify_of_claim(
            :seller => transaction.seller, 
            :buyer_contact => buyer_contact, 
            :transaction => transaction
          ).deliver
        end
        render status: 202, :json => {}
        
        transaction.update(:buyer_id => current_user.id)
        transaction.update(:sold_at => Time.now)

        # begin
        #   @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
        #   @client.account.messages.create(
        #       :from => ENV['TWILIO_NUMBER'],
        #       :to => transaction.seller.cellphone,
        #       :body => body
        #   )
        # rescue ArgumentError, Twilio::REST::RequestError => e
        #   error = e.message
        #   # If texting doesn't work, use email to notify seller
        #   TextbookMailer.notify_of_claim(:seller => transaction.seller, :buyer_contact => buyer_contact, :transaction => transaction).deliver
        # end
      
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
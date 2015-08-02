class TextbookTransactionsController < ApplicationController

  def index
    @textbook_transactions = TextbookTransaction.active.order('updated_at DESC').includes(:book => {:sections => {:course => :subdepartment}}).limit(18).map do |transaction|
      {
        :id => transaction.id,
        :price => "$" + transaction.price.to_s,
        :courses => transaction.book.sections.map(&:course).uniq.map(&:mnemonic_number).join(", "),
        :title => transaction.book.title,
        :book_id => transaction.book_id,
        :book_image => transaction.book.small_image_link,
        :author => transaction.book.author,
        :condition => transaction.condition,
        :notes => transaction.notes ? transaction.notes : "",
        :end_date => (transaction.created_at + 3.days).localtime.strftime("%b %d, %I:%M %p")
      }
    end
  end

  def listings
    @textbook_transactions = TextbookTransaction.active.order('updated_at DESC').includes(:book => {:sections => {:course => :subdepartment}}).map do |transaction|
      {
        :id => transaction.id,
        :price => "$" + transaction.price.to_s,
        :courses => transaction.book.sections.map(&:course).uniq.map(&:mnemonic_number).join(", "),
        :link => "/books/#{transaction.book.id}",
        :title => transaction.book.title,
        :book_id => transaction.book_id,
        :book_image => transaction.book.medium_image_link,
        :author => transaction.book.author,
        :condition => transaction.condition,
        :notes => transaction.notes ? transaction.notes : "none",
        :end_date => (transaction.created_at + 3.days).localtime.strftime("%b %d, %I:%M %p")
      }
    end

    render :json => @textbook_transactions
  end

  def books
    @books = Book.order("RAND()").pluck(:id, :title, :medium_image_link)

    respond_to do |format|
      format.html
      format.json { render :json => @books }
    end
  end

  def claim
    cell = params[:cellphone].strip
    current_user.update(:cellphone => cell)
    transaction = TextbookTransaction.find(params[:claim_id])
    body = "\"#{transaction.book.title}\" ($#{transaction.price})\nhas been claimed!\nBuyer's Contact info: #{current_user.cellphone}"
    
    if cell.length == 10
      if transaction.active?
        @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']

        begin
          @client.account.messages.create(
              :from => ENV['TWILIO_NUMBER'],
              :to => transaction.seller.cellphone,
              :body => body
          )
        rescue Twilio::REST::RequestError => e
          error = e.message
        end
        
        if error
          render status: 400, :json => {
            message: error
          }
        else
          transaction.update(:buyer_id => current_user.id)
          transaction.update(:sold_at => Time.now)
          render status: 202, :json => {}
        end

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
    current_user.update(:cellphone => params[:cellphone])

    if params[:cellphone].length == 10
      params[:seller_id] = current_user.id
      
      @textbook_transaction = TextbookTransaction.new(textbook_transaction_params)
      if @textbook_transaction.save
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
      expired: current_user.expired_listings,
      sold: current_user.sold_listings
    }
    @theaders = {
      active: ["Price", "Title", "Condition", "Expire Date", "Remove"],
      expired: ["Price", "Title", "Condition", "Expired Date", "Renew"],
      sold: ["Price", "Title", "Condition", "Sold Date", "Report"]
    }
    @date = {
      active: :updated_at,
      expired: :updated_at,
      sold: :sold_at
    }
    @date_action = {
      active: ["+", 3.days],
      expired: ["+", 3.days],
      sold: [:to_datetime]
    }
    @glyphicon_classes = {
      active: "glyphicon glyphicon-remove",
      expired: "glyphicon glyphicon-repeat",
      sold: "glyphicon glyphicon-flag"
    }
    @actions = {
      active: "withdraw",
      expired: "renew",
      sold: "report"
    }
    @listings_by_type.each_value do |listings|
      @count += listings.count
    end

    @claimed = current_user.claims

  end

  def withdraw
  end

  def renew
  end

  def report
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
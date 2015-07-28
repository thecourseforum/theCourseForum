class TextbookTransactionsController < ApplicationController

  def index
    @textbook_transactions = TextbookTransaction.active.order(:updated_at).includes(:book => {:sections => {:course => :subdepartment}}).limit(18).map do |transaction|
      {
        :id => transaction.id,
        :price => "$" + transaction.price.to_s,
        :courses => transaction.book.sections.map(&:course).uniq.map(&:mnemonic_number).join(", "),
        :title => transaction.book.title,
        :book_id => transaction.book_id,
        :author => transaction.book.author,
        :condition => transaction.condition,
        :notes => transaction.notes ? transaction.notes : "",
        :end_date => (transaction.created_at + 3.days).localtime.strftime("%b %d, %I:%M %p")
      }
    end
  end

  def listings
    @textbook_transactions = TextbookTransaction.active.order(:updated_at).includes(:book => {:sections => {:course => :subdepartment}}).map do |transaction|
      {
        :id => transaction.id,
        :price => "$" + transaction.price.to_s,
        :courses => transaction.book.sections.map(&:course).uniq.map(&:mnemonic_number).join(", "),
        :title => transaction.book.title,
        :book_id => transaction.book_id,
        :author => transaction.book.author,
        :condition => transaction.condition,
        :notes => transaction.notes ? transaction.notes : "",
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

    if cell.length == 10
      if transaction.active?
        response = RestClient.post 'http://textbelt.com/text', :number => transaction.seller.cellphone, :message => "Your posting for \"#{transaction.book.title}\" has been claimed!\nContact info: #{current_user.cellphone}"
        if JSON.parse(response)["success"]
          transaction.update(:buyer_id => current_user.id)
          transaction.update(:sold_at => Time.now)
          render :json => {
            status: "success"
          }
        else 
          render :json => {
            status: "Internal error"
          }
        end
      else
        render :json => {
          status: "Sorry! Already Claimed"
        }
      end
    else
      render :json => {
        status: "Badly formatted phone number"
      }
    end
  end

  def create
    current_user.update(:cellphone => params[:cellphone])

    if params[:cellphone].length == 10
      params[:seller_id] = current_user.id
      
      @textbook_transaction = TextbookTransaction.new(textbook_transaction_params)
      if @textbook_transaction.save
        render :json => {
          status: "success"
        }
      else 
        render :json => {
          status: "Missing values"
        }
      end
    else
      render :json => {
        status: "Badly formatted phone number"
      }
    end
    
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def textbook_transaction_params
      params[:textbook_transaction] = {
        :seller_id => params[:seller_id],
        :buyer_id => params[:buyer_id],
        :price => params[:price],
        :condition => params[:condition],
        :notes => params[:notes],
        :book_id => params[:book_id]
      }
      params.require(:textbook_transaction).permit(:cellphone, :price, :condition, :notes, :book_id, :seller_id, :buyer_id)
    end
end
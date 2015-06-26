class TextbookTransactionsController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    @textbook_transactions = TextbookTransaction.active
  end

  def search_book_titles
    
  end

  def data
    book = Book.where("title like ?", JSON.parse(params[:title])).first
    price = JSON.parse(params[:price])

    render :json => {
      seller_id: current_user.id,
      book_id: book.id,
      price: price
    }
  end

  def create
    puts "hello"
    puts params
    params[:book_id] = Book.where("title like ?", params[:title]).first.id
    @textbook_transaction = TextbookTransaction.new(textbook_transaction_params)
    render json: {:sucess => @textbook_transaction.save}
  end

  def new
  end

  def edit
  end

  def show
  end

  def update
  end

  def destroy
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def textbook_transaction_params
      params[:textbook_transaction] = {
        :price => params[:price],
        :condition => params[:condition],
        :book_id => params[:book_id]
      }
      params.require(:textbook_transaction).permit(:title, :cellphone, :price, :condition, :book_id, :seller_id, :buyer_id)
    end
end
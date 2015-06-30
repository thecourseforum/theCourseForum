class TextbookTransactionsController < ApplicationController

  def index
    @textbook_transactions = TextbookTransaction.active
  end

  def search_book_titles
    
  end

  def claim
    TextbookTransaction.find(params[:format]).update(:buyer_id => current_user.id)
    redirect_to action: "index"
  end

  def create
    current_user.update(:cellphone => params[:cellphone])
    params[:book_id] = Book.where("title like ?", params[:title]).first.id
    params[:seller_id] = current_user.id
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
        :seller_id => params[:seller_id],
        :buyer_id => params[:buyer_id],
        :price => params[:price],
        :condition => params[:condition],
        :book_id => params[:book_id]
      }
      params.require(:textbook_transaction).permit(:title, :cellphone, :price, :condition, :book_id, :seller_id, :buyer_id, :sell?)
    end
end
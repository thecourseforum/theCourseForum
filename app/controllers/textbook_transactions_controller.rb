class TextbookTransactionsController < ApplicationController

	def index
		@textbook_transactions = TextbookTransaction.active
	end

	def create
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
		def textbook_transaction_params
			params[:textbook_transaction] = {
				#TODO
			}
    end
end
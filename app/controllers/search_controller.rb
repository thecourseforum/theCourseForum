class SearchController < ApplicationController
  
  def search
    @query = params[:query]
    @search = Course.search do
      fulltext @query
    end
    @result = @search.results
    respond_to do |format|
      format.html
      format.json {render json: @result}
    end
  end

end

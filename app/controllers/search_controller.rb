class SearchController < ApplicationController
  
  def search
    @query_url = URI::escape(search_url + params[:query])
    @search = JSON.parse RestClient.get @query_url

    @result = @search["response"]["docs"]
    respond_to do |format|
      format.html
      format.json {render json: @result}
    end
  end

end

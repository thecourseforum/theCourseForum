class SearchController < ApplicationController
  
  def search
    @search_url_suffix = "/course_search?q="
    @query_url = URI::escape(ENV["SEARCH_URL"] + @search_url_suffix + params[:query])
    @search = JSON.parse RestClient.get @query_url

    @result = @search["response"]["docs"]
    respond_to do |format|
      format.html
      format.json {render json: @result}
    end
  end

end

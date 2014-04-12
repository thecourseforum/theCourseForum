class SchedulerController < ApplicationController

	def ui
	end

	def search
		if params[:courseno] == "cs2150"
			respond_to do |format|
      			format.html 
      			format.json { render json: "{test: 'success'}"}
      		end
      	end
	end

end
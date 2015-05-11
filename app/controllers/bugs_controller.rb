class BugsController < ApplicationController
  before_action :set_bug, only: [:show, :edit, :update, :destroy]

  # GET /bugs
  def index
    @bugs = Bug.all
  end

  def show
  end

  # POST /bugs
  def create
    @bug = Bug.new(bug_params)
    render json: {:success => @bug.save}
  end

  # DELETE /bugs/1
  def destroy
    @bug.destroy
    respond_to do |format|
      format.html { redirect_to bugs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bug
      @bug = Bug.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bug_params
      params[:bug] = {
        :url => params[:url],
        :description => params[:description],
        :email => params[:email]
      }
      params.require(:bug).permit(:url, :description, :email)
    end
end

class BugsController < ApplicationController
  skip_before_filter :authenticate_user!, only: :create
  before_action :set_bug, only: [ :show, :destroy ]

  before_action :verify_permission, only: [ :index, :show, :destroy ]

  # GET /bugs
  def index
    params[:type] ||= 'active'
    case params[:type]
    when 'active'
      @bugs = Bug.all.where(:archived => false).order(:created_at).reverse
    when 'archived'
      @bugs = Bug.all.where(:archived => true).order(:created_at).reverse
    when 'all'
      @bugs = Bug.all.order(:created_at).reverse
    end
  end

  def show
  end

  # POST /bugs
  def create
    @bug = Bug.new(bug_params)
    result = @bug.save
    ContactUsMailer.feedback(:id => @bug.id, :description => @bug.description).deliver
    render json: {:success => result}
  end

  # DELETE /bugs/1
  def destroy
    @bug.update(:archived => true)
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
        :email => params[:email],
        :archived => false
      }
      params.require(:bug).permit(:url, :description, :email, :archived)
    end

    def verify_permission
      if !current_user or !%w(aw3as@virginia.edu kra8ff@virginia.edu mah3xy@virginia.edu mjs5gw@virginia.edu lph5s@virginia.edu btw2cv@virginia.edu cyt3ea@virginia.edu djc4ku@virginia.edu).include?(current_user.email)
        head :unauthorized and return
      end
    end
end

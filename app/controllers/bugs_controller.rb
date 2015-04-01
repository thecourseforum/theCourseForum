class BugsController < ApplicationController
  before_action :set_bug, only: [:show, :edit, :update, :destroy]

  # GET /bugs
  def index
    @bugs = Bug.all
  end


  def show
  end

  # GET /bugs/new
  def new
    @bug = Bug.new
  end

  # GET /bugs/1/edit
  def edit
  end

  # POST /bugs
  def create
    pr params
    pr params[:title]
    @bug = Bug.new(title: params[:title], content: params[:content])
    @bug.save
    render :nothing => true
    # respond_to do |format|
    #   if @bug.save
    #     format.html { redirect_to @bug, notice: 'Bug was successfully created.' }
    #     format.json { render action: 'show', status: :created, location: @bug }
    #   else
    #     format.html { render action: 'new' }
    #     format.json { render json: @bug.errors, status: :unprocessable_entity }
    #   end
    # end
  end


  def update
    respond_to do |format|
      if @bug.update(bug_params)
        format.html { redirect_to @bug, notice: 'Bug was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @bug.errors, status: :unprocessable_entity }
      end
    end
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
      params.require(:bug).permit(:title, :content)
    end
end

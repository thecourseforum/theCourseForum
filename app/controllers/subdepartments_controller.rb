class SubdepartmentsController < ApplicationController

  # GET /subdepartments/1
  # GET /subdepartments/1.json
  def show
    @subdepartment = Subdepartment.find(params[:id])
    @courses = @subdepartment.courses

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @courses.to_json(include: :subdepartment) }
    end
  end

  private
    def subdepartment_params
      params.require(:subdepartment).permit(:mnemonic, :name)
    end

end

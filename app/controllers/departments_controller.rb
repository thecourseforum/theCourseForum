class DepartmentsController < ApplicationController

  def new
    @department = Department.new
  end

  def create
    @department = Department.new(params[:department])
    if @department.save
      flash[:success] = "Created new Dpeartment!"
      redirect_to @department
    else
      render 'new'
    end
  end

  def show
    @department = Department.find(params[:id])
  end

  def destroy
  end

  def index
    @departments = Department.all
  end
end
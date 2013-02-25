class SubdepartmentsController < ApplicationController
  # GET /subdepartments
  # GET /subdepartments.json
  def index
    @subdepartments = Subdepartment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subdepartments }
    end
  end

  # GET /subdepartments/1
  # GET /subdepartments/1.json
  def show
    @subdepartment = Subdepartment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @subdepartment }
    end
  end

  # GET /subdepartments/new
  # GET /subdepartments/new.json
  def new
    @subdepartment = Subdepartment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @subdepartment }
    end
  end

  # GET /subdepartments/1/edit
  def edit
    @subdepartment = Subdepartment.find(params[:id])
  end

  # POST /subdepartments
  # POST /subdepartments.json
  def create
    @subdepartment = Subdepartment.new(params[:subdepartment])

    respond_to do |format|
      if @subdepartment.save
        format.html { redirect_to @subdepartment, notice: 'Subdepartment was successfully created.' }
        format.json { render json: @subdepartment, status: :created, location: @subdepartment }
      else
        format.html { render action: "new" }
        format.json { render json: @subdepartment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /subdepartments/1
  # PUT /subdepartments/1.json
  def update
    @subdepartment = Subdepartment.find(params[:id])

    respond_to do |format|
      if @subdepartment.update_attributes(params[:subdepartment])
        format.html { redirect_to @subdepartment, notice: 'Subdepartment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @subdepartment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subdepartments/1
  # DELETE /subdepartments/1.json
  def destroy
    @subdepartment = Subdepartment.find(params[:id])
    @subdepartment.destroy

    respond_to do |format|
      format.html { redirect_to subdepartments_url }
      format.json { head :no_content }
    end
  end
end

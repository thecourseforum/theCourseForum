class BooksController < ApplicationController

  def index
  end

  def course
    unless params[:mnemonic] and params[:course_number]
      render :nothing => true, :status => 404 and return
    else
      # Find the subdepartment by the given mnemonic
      subdept = Subdepartment.find_by(:mnemonic => params[:mnemonic])
      # Find the course by that subdepartment id and the given course number
      course = Course.find_by(:subdepartment_id => subdept.id, :course_number => params[:course_number]) if subdept
      # return an error if no such course was found
      render :nothing => true, :status => 404 and return unless course

      # Breaks up the course's sections by type, convertubg them to javascript sections,
      # and wraps the result in json
      render :json => course.to_json(:include => :books)
    end
  end

end

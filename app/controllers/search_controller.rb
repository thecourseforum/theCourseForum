class SearchController < ApplicationController
  
  def search
    # @search_url_suffix = "/course_search?q="
    @query = params[:query].strip
    # @query_url = URI::escape(ENV["SEARCH_URL"] + @search_url_suffix + params[:query])
    # @search = JSON.parse RestClient.get @query_url

    # @result_temp = @search["response"]["docs"]
    # @result = @result_temp.paginate(:page => params[:page], :per_page=> 20)
    @departments = []
    @courses = []
    @professors = []
    strings = params[:query].split(' ')

    if @query.length > 1
      if strings.length == 2 and strings[0].length < 5 and strings[1].length == 4
        search_mnemonic_numbers(*strings)
      elsif strings.length == 1
        if !!/\A\d+\z/.match(strings[0])
          search_numbers(strings[0])
        elsif strings[0].length < 5
          search_mnemonic(strings[0])
          if strings[0].length > 2
            search_titles(strings[0])
            search_professors(strings[0])
          end
        else
          search_departments(strings[0])
          search_titles(strings[0])
          search_professors(strings[0])
        end
      elsif strings.length == 2
        search_professors_full_name(strings[0], strings[1])
        search_titles(params[:query])
      else
        search_titles(params[:query])
      end
    end

    @departments = @departments.uniq(&:first)
    @count = @departments.count + @courses.count + @professors.count

    respond_to do |format|
      format.html
      format.json {render json: {
        departments: @departments,
        courses: @courses,
        professors: @professors
      }
    }
    end
  end

  private

  def search_mnemonic(query)
    @departments += Subdepartment.where("mnemonic LIKE ?", "%#{query}%").map do |subdepartment|
      subdepartment.departments.map do |department|
          {
            :id => department.id,
            :name => department.name
          }
      end
    end.flatten
  end

  def search_departments(query)
    @departments += Department.where("name LIKE ?", "%#{query}%").map do |department|
      {
        :id => department.id,
        :name => department.name
      }
    end
  end

  def search_titles(query)
    @courses += Course.where("title LIKE ?", "%#{query}%").map do |course|
      {
        :id => course.id,
        :mnemonic_number => course.mnemonic_number,
        :title => course.title
      }
    end
  end

  def search_professors(query)
    @professors += Professor.where("first_name LIKE ? OR last_name LIKE ?", "%#{query}%", "%#{query}%").map do |professor|
      {
        :id => professor.id,
        :full_name => professor.full_name,
      }
    end
  end

  def search_professors_full_name(first, last)
    @professors += Professor.where("first_name LIKE ? AND last_name LIKE ?",  "%#{first}%", "%#{last}%").map do |professor|
      {
        :id => professor.id,
        :full_name => professor.full_name,
      }
    end
  end

  def search_numbers(number)
    @courses += Course.where("course_number LIKE ?", "%#{number}%").map do |course|
      {
        :id => course.id,
        :mnemonic_number => course.mnemonic_number,
        :title => course.title
      }
    end
  end


  def search_mnemonic_numbers(mnemonic, number)
    course = Course.find_by_mnemonic_number("#{mnemonic} #{number}")
    if course
      @courses += [{
        :id => course.id,
        :mnemonic_number => course.mnemonic_number,
        :title => course.title
      }]
    end
  end

end

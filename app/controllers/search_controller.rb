class SearchController < ApplicationController
  
  def search
    # @search_url_suffix = "/course_search?q="
    @query = params[:query]
    # @query_url = URI::escape(ENV["SEARCH_URL"] + @search_url_suffix + params[:query])
    # @search = JSON.parse RestClient.get @query_url

    # @result_temp = @search["response"]["docs"]
    # @result = @result_temp.paginate(:page => params[:page], :per_page=> 20)
    @results = []
    strings = params[:query].split(' ')

    timing = Time.now
    if strings.length == 2 and strings[0].length < 5 and strings[1].length == 4
      search_mnemonic_numbers(*strings)
    elsif strings.length == 1
      if strings[0].to_i.to_s == strings[0]
        search_numbers(strings[0])
      elsif strings[0].length < 5
        search_mnemonic(strings[0])
        if strings[0].length > 2
          search_titles(strings[0])
          search_professors(strings[0])
        end
      else
        search_titles(strings[0])
        search_professors(strings[0])
      end
    elsif strings.length == 2
      search_professors_full_name(strings[0], strings[1])
      search_titles(params[:query])
    else
      search_titles(params[:query])
    end
  
    @result = @results.paginate(:page => params[:page], :per_page => 20)
    respond_to do |format|
      format.html
      format.json {render json: @result}
    end
  end

  def search_subdepartment
    strings = params[:query].split(' ')

    mnemonic = strings[0]

    results = []
    if mnemonic.length < 5 and mnemonic.to_i.to_s != mnemonic
      results = Subdepartment.where("mnemonic LIKE ?", "%#{mnemonic}%").includes(:courses).map do |subdepartment|
        subdepartment.courses.map do |course|
          {
            :course_id => course.id,
            :mnemonic_number => "#{subdepartment.mnemonic} #{course.course_number}",
            :title => course.title
          }
        end
      end.flatten
    end

    render :json => results
  end

  private

  def search_mnemonic(query)
    @results += Subdepartment.where("mnemonic LIKE ?", "%#{query}%").includes(:courses => :professors).map do |subdepartment|
      subdepartment.courses.map do |course|
        course.professors.uniq.map do |professor|
          {
            :course_id => course.id,
            :professor_id => professor.id,
            :mnemonic_number => course.mnemonic_number,
            :full_name => professor.full_name,
            :title => course.title,
            :course => course 
          }
        end
      end
    end.flatten
  end

  def search_titles(query)
    @results += Course.where("title LIKE ?", "%#{query}%").includes(:professors, :subdepartment).map do |course|
      course.professors.map do |professor|
        {
          :course_id => course.id,
          :professor_id => professor.id,
          :mnemonic_number => course.mnemonic_number,
          :full_name => professor.full_name,
          :title => course.title,
          :course => course

        }
      end.uniq
    end.flatten
  end

  def search_professors(query)
    @results += Professor.where("first_name LIKE ? OR last_name LIKE ?", "%#{query}%", "%#{query}%").includes(:courses => :subdepartment).map do |professor|
      professor.courses.uniq.map do |course|
        {
          :course_id => course.id,
          :professor_id => professor.id,
          :mnemonic_number => course.mnemonic_number,
          :full_name => professor.full_name,
          :title => course.title,
          :course => course
        }
      end
    end.flatten
  end

  def search_professors_full_name(first, last)
    @results += Professor.where("first_name LIKE ? AND last_name LIKE ?",  "%#{first}%", "%#{last}%").includes(:courses => :subdepartment).map do |professor|
      professor.courses.uniq.map do |course|
        {
          :course_id => course.id,
          :professor_id => professor.id,
          :mnemonic_number => course.mnemonic_number,
          :full_name => professor.full_name,
          :title => course.title,
          :course => course
        }
      end
    end.flatten
  end

  def search_numbers(number)
     @results += Course.where("course_number LIKE ?", "%#{number}%").includes(:professors, :subdepartment).map do |course|
      course.professors.map do |professor|
        {
          :course_id => course.id,
          :professor_id => professor.id,
          :mnemonic_number => course.mnemonic_number,
          :full_name => professor.full_name,
          :title => course.title,
          :course => course
        }
      end.uniq
    end.flatten
  end


  def search_mnemonic_numbers(mnemonic, number)
    course = Course.find_by_mnemonic_number("#{mnemonic} #{number}")
    if course
      @results += course.professors.map do |professor|
        {
          :course_id => course.id,
          :professor_id => professor.id,
          :mnemonic_number => course.mnemonic_number,
          :full_name => professor.full_name,
          :title => course.title,
          :course => course
        }
      end.uniq
    end
  end

end

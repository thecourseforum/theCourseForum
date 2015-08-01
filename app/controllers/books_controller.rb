class BooksController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
  end

  def courses
    mnemonics = JSON.parse(params[:mnemonics])
    courses = mnemonics.map do |mnemonic_number|
      mnemonic = /^[A-z]{2,4}/.match(mnemonic_number)[0].upcase
      number = /[1-9]\d{3}$/.match(mnemonic_number)[0]
      Course.find_by_mnemonic_number("#{mnemonic} #{number}")
    end.compact

    books = courses.map do |course|
      course.books.map do |book|
        book.as_json.merge({
          :course => course.mnemonic_number,
          :course_id => course.id
        })
      end
    end

    render :json => books.flatten
  end

  def search_subdepartment
    entries = params[:query].split(',')
    entries.map!(&:strip)
    prefix = entries.size > 1 ? entries[0...-1].join(", ") + ", " : ""

    strings = entries.last.split(' ')

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

    render :json => [prefix,results]
  end

end

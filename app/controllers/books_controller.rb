class BooksController < ApplicationController

  def index
  end

  def courses
    mnemonics = JSON.parse(params[:mnemonics])
    courses = mnemonics.map do |mnemonic_number|
      mnemonic = /^[A-z]{2,4}/.match(mnemonic_number)[0].upcase
      number = /[1-9]\d{3}$/.match(mnemonic_number)[0]
      Course.find_by_mnemonic_number(mnemonic, number)
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

end

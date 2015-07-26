class BooksController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
  end

  def show
    book = Book.find(params[:id])
    @book = {
      :book => book,
      :image => (book.large_image_link ? book.large_image_link : "/assets/icons/no_book.png"),
      :affiliate_link => (book.amazon_affiliate_link ? book.amazon_affiliate_link : "#"),
      :new_bookstore => (book.bookstore_new_price ? "$" + sprintf('%.2f', book.bookstore_new_price) : "N/A"),
      :used_bookstore => (book.bookstore_used_price ? "$" + sprintf('%.2f', book.bookstore_used_price) : "N/A"),
      :new_official_amazon => (book.amazon_official_new_price ? "$" + sprintf('%.2f', book.amazon_official_new_price) : "N/A"),
      :used_official_amazon => (book.amazon_official_used_price ? "$" + sprintf('%.2f', book.amazon_official_used_price) : "N/A"),
      :new_merchant_amazon => (book.amazon_merchant_new_price ? "$" + sprintf('%.2f', book.amazon_merchant_new_price) : "N/A"),
      :used_merchant_amazon => (book.amazon_merchant_used_price ? "$" + sprintf('%.2f', book.amazon_merchant_used_price) : "N/A")
    }
    @sections = Section.find(book.sections.pluck(:id, :course_id).uniq(&:second).map(&:first))
    @textbook_transactions = book.textbook_transactions.active
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

  def follow
    @book = Book.find(params[:book_id])

    if current_user.books.include?(@book)
      current_user.books.delete(@book)
      render :json => {
        status: "unfollowed"
      }
    else
      current_user.books.append(@book)
      render :json => {
        status: "followed"
      }
    end
  end

end

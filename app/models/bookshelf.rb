class Bookshelf
  require 'csv'
  require 'open-uri'

  attr_reader :user_id, :books

  def initialize(user_id, *options)
    @user_id = user_id
    @options = options
    @books = []

    self
  end

  def fetch
    @books = read_bookshelf { |books_count| yield books_count }

    @books
  end

  def to_csv
    csv_string = CSV.generate do |csv|
      csv << ['Title', 'Author', 'ISBN', 'Publisher', 'Bookshelves']
      @books.each do |book|
        csv << [book.title, book.author, book.isbn, book.publisher, 'read']
      end
    end
  end

  private

  def read_bookshelf
    page = 1
    books = []

    while true do
      url = SkoobUrls.bookshelf_read(user_id, page)
      data = JSON.load(open(url)).deep_symbolize_keys

      data[:response].each do |book|
        books << Book.new(book[:edicao])
        yield books.length if block_given?

        break if just_first_book?
      end

      page += 1

      break if data[:response].empty? || just_first_book? || just_first_page?
    end

    books
  end

  def just_first_book?
    @options.include?(:just_first_book)
  end

  def just_first_page?
    @options.include?(:just_first_page)
  end
end

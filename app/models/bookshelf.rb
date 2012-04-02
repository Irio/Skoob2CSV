# -*- encoding : utf-8 -*-
class Bookshelf
  require "csv"
 
  attr_reader :user_id,
              :books,
              :updated_at
               
  def initialize(user_id, *options)
    @user_id    = user_id
    @options    = options
    @books      = []
    @updated_at = nil

    self
  end

  def fetch
    @books = read_bookshelf
    @updated_at = DateTime.now
    @books
  end

  def to_csv
    fetch unless @updated_at 

    csv_string = CSV.generate do |csv|
      csv << ["Title", "Author", "ISBN", "Publisher", "Bookshelves"]
      @books.each do |book|
        csv << [book.title, book.author, book.isbn, book.publisher, "read"]
      end
    end
  end

  private
  def read_bookshelf
    page  = 1
    books = []
    while true do 
      url  = SkoobUrls.bookshelf_read(@user_id, page)
      html = Html.parse(url)
      
      (html/".clivro").each do |book_node|
        
        book_bookshelf_id = book_node.get_attribute("id")
        books << Book.new(book_bookshelf_id)
        puts "Skoob :: read_bookshelf(#{@user_id}) :: page=#{page} book=#{@books.length + books.length}"

        break if @options.include?(:just_first_book)
      end
      page += 1

      break if @options.include?(:just_first_book) or @options.include?(:just_first_page)
      break if (parsed_estante/".clivro img.ccapa").empty?
    end
    books
  end
end

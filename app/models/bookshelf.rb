# -*- encoding : utf-8 -*-
class Bookshelf
  require "csv"

  def get(id, options = Hash.new)
    books = bookshelf(id, options)
    csv_string = CSV.generate do |csv|
      csv << ["Title", "Author", "ISBN", "Publisher", "Bookshelves"]
      books.each do |book|
        csv << [book.title, book.author, book.isbn, book.publisher, "read"]
        p book
      end
    end
  end

  def bookshelf(id, options = Hash.new)
    page  = 1
    books = []

    while true do 
      url  = SkoobUrls.bookshelf_read(id, page)
      html = Html.parse(url)
      
      (html/".clivro").each do |book_node|
        book_bookshelf_id = book_node.get_attribute("id")
        books << Book.new(book_bookshelf_id)
        break if options[:just_first_book]
      end
      page += 1

      break if options[:just_first_book] or options[:just_first_page]
      break if (parsed_estante/".clivro img.ccapa").empty?
    end

    books
  end
end

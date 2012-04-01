# -*- encoding : utf-8 -*-
class Book
  attr_reader :id,
              :bookshelf_id,
              :title,
              :isbn,
              :author,
              :publisher,
              :pages,
              :edition_id,
              :edition

  def initialize(bookshelf_id = "")
    @bookshelf_id = bookshelf_id

    read_bookshelf
    read_edition
  end 
 
  private 
  def read_bookshelf
    if @bookshelf_id
      url   = SkoobUrls.bookshelf_book(@bookshelf_id)
      html  = Html.parse(url)
      
      # Get id
      regex     = /\/livro\/(\d+)/
      book_node = (html/"#wd_referente").first
      book_path = (book_node/"a")[0].get_attribute("href")
      @id       = regex.match(book_path)[1]
      
      # Get title
      @title = (html/"a.l20b").inner_html

      # Get author, pages and publisher
      regex = /(?<author>.*) - (?<pages>\d+) páginas - (?<publisher>.*)/
      autor_pages_publisher = (html/"#wd_referente span").first.inner_html
      autor_pages_publisher = regex.match(autor_pages_publisher)
      @author    = autor_pages_publisher[:author]
      @pages     = autor_pages_publisher[:pages]
      @publisher = autor_pages_publisher[:publisher]

      # Get edition_id
      regex = Regexp.new("icones#{@id}(\\d+)")
      string_with_book_edition_id = (html/"[@id*=icones]").first.get_attribute("id")
      @edition_id = regex.match(string_with_book_edition_id)[1]
    end
  end
  
  def read_edition
    if @id
      url   = SkoobUrls.book_editions(@id)
      html  = Html.parse(url)
     
      book_edition_path = SkoobUrls.book_edition(@edition_id, true)
      (html/"#corpo > div > div > div").each do |book_node| 
        book_data = book_node.search("span")
        regex = Regexp.new(@publisher)
        if regex.match(book_data[1].next.inner_text) and
           book_data[4].next.inner_text == " " + @pages
        
          @edition  = book_data[0].next.inner_text[1..-1]
          @isbn     = book_data[2].next.inner_text[1..-1]
        end
      end
    end
  end
end

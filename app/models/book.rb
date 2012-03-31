# -*- encoding : utf-8 -*-
class Book
  attr_accessor :id,
                :bookshelf_id,
                :title,
                :pages,
                :publisher = ".*",
                :isbn = ".*" 

  def get_titles_by_estante(options = Hash.new)
    estante_url = Skoob_url + Estante_lidos_path + @id.to_s
    page        = 1
    books       = []

    while true do 
      estante_url_with_page = estante_url + "/est:h/mpage:" + page.to_s
      parsed_estante        = parse(estante_url_with_page)
      
      (parsed_estante/".clivro img.ccapa").each do |capa|
        book = Hash.new
        book[:title] = capa.get_attribute("title")

        book_id = /amazonaws.com\/livros\/(\d+)/.match(capa.get_attribute("src"))[1]
        if book[:title].empty?
          book[:title] = get_title(book_id)
        end
        
        book[:publisher] = get_publisher
        book[:pages]     = get_pages
        book[:isbn]      = get_isbn

        books << book
        break if options[:just_first_book]
      end
      page += 1

      break if options[:just_first_book] or options[:just_first_page]
      break if (parsed_estante/".clivro img.ccapa").empty?
    end

    books
  end

  def get_title(id)
    book_url         = Skoob_url + Book_path + id.to_s
    parsed_book_page = parse(book_url)
    (parsed_book_page/"#barra_titulo h1").inner_html
  end

  def get_pages(id)
    regex            = /(?<author>.*) - (?<pages>\d+) páginas - (?<publisher>.*)/
    book_url         = Skoob_url + Book_path + id.to_s
    parsed_book_page = parse(book_url)
    
    autor_pages_publisher = (parsed_book_page/"#wd_referente span").first
    /(?<author>.*) - (?<pages>\d+) páginas - (?<publisher>.*)/
    regex.match(autor_pages_publisher)[:pages]
  end
  
  def get_publisher(id)
    regex            = /(?<author>.*) - (?<pages>\d+) páginas - (?<publisher>.*)/
    book_url         = Skoob_url + Book_path + id.to_s
    parsed_book_page = parse(book_url)
    
    autor_pages_publisher = (parsed_book_page/"#wd_referente span").first
    binding.pry
    regex.match(autor_pages_publisher)[:publisher]
  end

  def get_isbn(id, publisher = ".*", pages = ".*")
    book_edicoes_url = Skoob_url + Book_edicoes_path + id.to_s
    parsed_book_page = parse(book_edicoes_url)
    
    regex_estante_book = /Editora:<\/span> #{publisher}.+Páginas:<\/span> #{pages}/
    
    (parsed_book_page/"#corpo > div > div > div").each do |book_node|
      book_node_html = book_node.inner_html
      if regex_estante_book.match(book_node_html)
        return (/ISBN:<\/span> (\w+)/.match(book_node_html)[1])
      end
    end
  end

  private
  def parse(url)
    page = Iconv.new('UTF-8//IGNORE', 'UTF-8').conv(open(url).readlines.join("\n"))
    Hpricot(page)
  end
end

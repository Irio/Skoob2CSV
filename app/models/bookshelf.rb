class Bookshelf
  require "open-uri"
  require "iconv"

  Skoob_url          = "http://www.skoob.com.br"
  Estante_lidos_path = "/estante/livros/todos/"
  Book_path          = "/livro/"
  
  def get(id, options = Hash.new)
    get_titles_by_estante(id, options)
  end

  def get_titles_by_estante(id, options = Hash.new)
    estante_url = Skoob_url + Estante_lidos_path + id.to_s
    page        = 1
    books       = []

    while true do
      estante_url_with_page = estante_url + "/mpage:" + page.to_s
      parsed_estante        = parse(estante_url_with_page)
      
      (parsed_estante/".clivro img.ccapa").each do |capa|
        book = Hash.new
        book[:title] = capa.get_attribute("title")

        if book[:title].empty?
          book_id = /amazonaws.com\/livros\/(\d+)/.match(capa.get_attribute("src"))[1]
          book[:title] = get_by_book_page(book_id)
        end

        books << book
        break if options[:just_first_book]
      end
      page += 1

      break if options[:just_first_book] or options[:just_first_page]
      break if (parsed_estante/".clivro img.ccapa").empty?
    end

    books
  end

  def get_by_book_page(id)
    book_url         = Skoob_url + Book_path + id.to_s
    parsed_book_page = parse(book_url)
    (parsed_book_page/"#barra_titulo h1").inner_html
  end

  private
  def parse(url)
    page = Iconv.new('UTF-8//IGNORE', 'UTF-8').conv(open(url).readlines.join("\n"))
    Hpricot(page)
  end
end
class BookshelfController < ApplicationController
  def index
  end

  def show
    require "open-uri"
    require "iconv"

    skoob_url    = "http://www.skoob.com.br"
    estante_path = "/estante/livros/todos/"
    page         = 1
    books        = []

    if params[:id]
        
      while true do
        skoob_url_page = skoob_url + estante_path + params[:id] + "/mpage:#{page}"
        skoob = Iconv.conv('utf-8', 'iso-8859-1', open(skoob_url_page).readlines.join("\n"))
        h_skoob = Hpricot(skoob)
        
        (h_skoob/".clivro img.ccapa").each do |capa|
          book = Hash.new
          book[:title] = capa.get_attribute("title")

          books << book
        end
        page += 1
       break if (h_skoob/".clivro img.ccapa").empty?
      end
    else
      render :nothing
    end
  end

end

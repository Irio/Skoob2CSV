class SkoobUrls
  Skoob_url = "http://www.skoob.com.br"
  
  def self.bookshelf_read(user_id, page = 1)
    "#{Skoob_url}/estante/livros/1/#{user_id}/est:h/mpage:#{page}"
  end

  def self.bookshelf_book(id)
    "#{Skoob_url}/estante/livro/#{id}"
  end

  def self.book_editions(id)
    "#{Skoob_url}/livro/edicoes/#{id}"
  end

  def self.book_edition(id, just_path = true)
    if just_path
      "/edicao/#{id}/"
    else
      "#{Skoob_url}/edicao/#{id}"
    end
  end
end

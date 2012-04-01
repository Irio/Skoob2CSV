class Html
  def self.parse(url)
    require "open-uri"
    require "iconv"
  
    page = Iconv.new('UTF-8//IGNORE', 'UTF-8').conv(open(url).readlines.join("\n"))
    Hpricot(page)
  end
end

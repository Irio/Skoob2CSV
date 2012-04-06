# encoding: UTF-8
class BookshelfController < ApplicationController
  def index
  end

  def show
    if params[:id]

      unless params[:format] == "csv"
        redirect_to format: "csv"
        return false
      end

      bookshelf = Bookshelf.new(params[:id])

      bookshelf.fetch do |books_count|
        puts "#{books_count} books' info saved."
      end
      
      response.headers["Content-Type"] = 'text/csv'
      render text: bookshelf.to_csv
    else
      render :nothing
    end
  end

end

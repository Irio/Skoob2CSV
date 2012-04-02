class BookshelfController < ApplicationController
  def index
  end

  def show
    if params[:id]
      unless params[:format] == "csv"
        redirect_to controller: "bookshelf", action: "show", format: "csv"
        return false
      end
      bookshelf = Bookshelf.new(params[:id])
      
      response.headers["Content-Type"] = 'text/csv'
      render text: bookshelf.to_csv
    else
      render :nothing
    end
  end

end

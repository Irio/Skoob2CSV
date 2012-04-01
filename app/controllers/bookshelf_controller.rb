class BookshelfController < ApplicationController
  def index
  end

  def show
    if params[:id]
      binding.pry
      unless params[:format] == "csv"
        redirect_to controller: "bookshelf", action: "show", format: "csv"
        return false
      end
      bookshelf = Bookshelf.new
      render inline: bookshelf.get(params[:id])
    else
      render :nothing
    end
  end

end

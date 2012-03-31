class BookshelfController < ApplicationController
  def index
  end

  def show
    if params[:id]
      bookshelf = Bookshelf.new
      p bookshelf.get(params[:id])
    else
      render :nothing
    end
  end

end

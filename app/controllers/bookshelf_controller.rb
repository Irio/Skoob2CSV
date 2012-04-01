class BookshelfController < ApplicationController
  def index
  end

  def show
    if params[:id]
      bookshelf = Bookshelf.new
      render bookshelf.get(params[:id], {just_first_page: true})
    else
      render :nothing
    end
  end

end

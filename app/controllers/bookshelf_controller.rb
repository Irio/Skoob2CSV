# encoding: UTF-8
class BookshelfController < ApplicationController
  def index
  end

  def create
    if params[:id].present?
      bookshelf = Bookshelf.new(params[:id])

      bookshelf.fetch do |books_count|
        puts "#{books_count} books' info saved."
      end

      response.headers['Content-Type'] = 'text/csv'
      render text: bookshelf.to_csv
    else
      flash[:error] = 'ID de usuário inválido'
      redirect_to root_path
    end
  end
end

Skoob2CSV::Application.routes.draw do
  get '/:id' => 'bookshelf#show', as: "show_bookshelf"

  root :to => 'bookshelf#index'
end

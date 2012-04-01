Skoob2CSV::Application.routes.draw do
  get '/:id' => 'bookshelf#show'
  get 'index' => 'bookshelf#index'

  root :to => 'bookshelf#index'
end

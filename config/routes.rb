Rails.application.routes.draw do
  # post '/:id', to: 'bookshelf#create', as: 'create_bookshelf_csv', defaults: { format: 'csv' }

  resources :bookshelf, only: :create, as: 'create_bookshelf_csv', format: 'csv'

  root to: 'bookshelf#index'
end

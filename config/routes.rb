require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :products
  get "up" => "rails/health#show", as: :rails_health_check

  # Conjunto de rotas para o "Carrinho"
  resource :cart, only: [:show, :create], controller: 'carts' do
    post :add_item, on: :collection                                               # Altera a quantidade de um produto já existente no carrinho.
    delete ':product_id', action: :remove_item, on: :collection, as: :remove_item # Remove um item do carrinho com base no ID do produto.
  end

  root "rails/health#show"

  
  end

Rails.application.routes.draw do
  get 'orders/edit'
  get 'orders/index'
  get 'orders/new'
  get 'orders/show'
  get 'carts/show'
  devise_for :users
  root 'static_pages#home'
  get  '/help', to: 'static_pages#help', as: 'helf'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'

  resources :products
  resources :orders
  resources :users

  get 'carts/:id' => 'carts#show', as: 'cart'
  delete 'carts/:id' => 'carts#destroy'

  post 'line_items/:id/add' => 'line_items#add_quantity', as: 'line_item_add'
  post 'line_items/:id/reduce' => 'line_items#reduce_quantity', as: 'line_item_reduce'
  post 'line_items' => 'line_items#create'
  get 'line_items/:id' => 'line_items#show', as: 'line_item'
  delete 'line_items/:id' => 'line_items#destroy'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

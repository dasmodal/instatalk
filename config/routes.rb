Rails.application.routes.draw do
  root 'rooms#index'

  resources :rooms, only: %i[create index show], param: :token
end

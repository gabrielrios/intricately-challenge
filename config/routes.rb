Rails.application.routes.draw do

  resources :dns_records, only: [:index, :create]
end

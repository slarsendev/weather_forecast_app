Rails.application.routes.draw do
  resources :forecasts, only: %i(show)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "forecasts#show"
end

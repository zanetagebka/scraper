Rails.application.routes.draw do
  get '/data', to: 'scraper#extract'
  root 'scraper#index'
end 
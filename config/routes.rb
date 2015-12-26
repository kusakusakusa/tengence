Rails.application.routes.draw do
  devise_for :users, controllers: { 
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords:  "users/passwords" }
  devise_scope :user do
    get "users/check_email_taken"=> 'users/registrations#check_email_taken',
      :as => :check_email_taken
  end

  # static pages
  root 'pages#home'
  post 'contact_us_email', to: 'pages#contact_us_email'
  get 'post-a-tender', to: 'pages#post_a_tender'
  get 'terms-of-service', to: 'pages#terms_of_service'
  get 'refresh_cloudsearch', to: 'pages#refresh_cloudsearch'

  # braintree
  # resources :payment_methods, path: '/payment-methods'
  get "/billing", to: 'brain_tree#billing'
  get "/subscribe", to: 'brain_tree#subscribe', as: 'subscribe'
  post "/create_payment", to: 'brain_tree#create_payment'

  get '/current_tenders', to: 'current_tenders#index', as: :current_tenders
  get '/past_tenders', to: 'past_tenders#index', as: :past_tenders
  get '/current_posted_tenders', to: 'current_posted_tenders#index', as: :current_posted_tenders
  get '/past_posted_tenders', to: 'past_posted_tenders#index', as: :past_posted_tenders
  get '/keywords_tenders', to: 'keywords_tenders#index', as: :keywords_tenders
  post '/update_keywords', to: 'keywords_tenders#update_keywords', as: :update_keywords
  post '/mass_destroy', to: 'watched_tenders#mass_destroy', as: :mass_destroy

  resources :tenders
  resources :watched_tenders
  resources :viewed_tenders

  resource :user do
    get 'keywords', to: 'users/keywords#edit'
    post 'keywords', to: 'users/keywords#update'
  end

  require 'sidekiq/web'
  authenticate :user, lambda { |u| ["vljc17@gmail.com","ganthertay@gmail.com"].include? u.email } do
    mount Sidekiq::Web => '/sidekiq'
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end
end

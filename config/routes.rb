require "sidekiq/web"

Rails.application.routes.draw do
  root to: "pages#current"

  resources :teams, only: [:show]
  resources :games, only: [:show]
  resources :player_awards, except: [:index, :destroy]

  get :spring, to: "pages#spring"
  get :summer, to: "pages#summer"
  get :fall, to: "pages#fall"
  get :stats, to: "stats#index"
  get :standings, to: "stats#standings"
  get "stats/:league_id", to: "stats#index", as: :league_stats
  get "standings/:league_id", to: "stats#standings", as: :league_standings

  post "payments/credit_card", as: :credit_card
  post "payments/cash",        as: :cash

  resources :assessments, only: :update
  resources :questionnaires, only: [:show, :create, :update]

  # Sessions, Users, Registrations
  resources :users, only: [:new, :create]
  get :profile, to: "users#show"
  get "profile/edit", to: "users#edit", as: :edit_profile
  put :profile, to: "users#update"
  delete :profile, to: "users#destroy"
  resource :session, only: [:new, :create, :destroy]
  get "auth/:provider/callback", to: "authentications#create"
  resources :authentications, only: [:destroy]
  get :forgot_password, to: "passwords#new"
  post :password, to: "passwords#create"
  get :password, to: "passwords#edit"
  put :password, to: "passwords#update"
  get "register/:league_id", to: "registrations#create", as: :register
  get "unregister/:league_id", to: "registrations#destroy", as: :unregister
  resource :subscription, only: [:create, :show, :destroy]

  get :feed, to: "drafts#feed"
  resources :drafts, only: [] do
    get :feed, on: :member
    get :turn, on: :member
  end

  get :admin, to: "admin/teams#index"
  namespace :admin do
    resources :teams
    resources :captains
    resources :users
    resources :events
    resources :games do
      resource :stats, only: [:edit, :update]
    end
    resources :player_awards, only: :index
  end

  get :super, to: "super/announcements#index"
  namespace :super do
    resources :announcements
    resources :emails do
      post :preview, on: :member
      post :send, on: :member, to: "emails#email"
    end
    resources :images
    resources :pages
    resources :leagues
    resources :drafts do
      get :order, on: :member
      post :order, on: :member, to: "drafts#update_order"
      delete :reset, on: :member
    end
    resources :fields
    resources :users, only: [:index, :update] do
      put :export, on: :collection
      put :assign, on: :collection
      put :trade, on: :collection
      get :shirt_sizes, on: :collection
    end
    resources :baggages do
      post :approve, on: :member
    end
  end

  get :captain, to: "captain/captains#index"
  namespace :captain do
    resources :drafts, only: [:index, :show]
    resources :games, only: [:index, :show]
    resources :users, only: :index

    resources :drafted_players, only: [:create] do
      post :create_from_tentative, on: :collection
    end
    resources :tentative_players, only: [:create, :destroy]
  end

  mount Sidekiq::Web, at: :sidekiq, constraints: TomConstraint.new

  get ":path", to: "pages#page", as: :page
end

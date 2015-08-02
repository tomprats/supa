Supa::Application.routes.draw do
  root to: "pages#current"

  devise_for :users, controllers: {
    omniauth_callbacks: "authentications",
    registrations: "registrations"
  }

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

  get  "payments/checkout"
  get  "payments/success"
  post "payments/notify"
  get  "payments/cancel"
  post "payments/credit_card", as: :credit_card
  post "payments/cash",        as: :cash

  devise_scope :user do
    resources :authentications
    resources :assessments, only: :update
    resources :questionnaires, only: [:show, :create, :update]

    get "sign_in", to: "devise/sessions#new"
    delete "sign_out", to: "devise/sessions#destroy"
    get "register", to: "registrations#register"
    get "unregister", to: "registrations#unregister"
    get "profile", to: "registrations#show"

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
      resources :pages
      resources :leagues
      resources :drafts do
        get :order, on: :member
        post :order, on: :member, to: :update_order
        delete :reset, on: :member
      end
      resources :fields
      resources :users, only: [:index, :update] do
        put :export, on: :collection
        put :assign, on: :collection
        put :trade, on: :collection
      end
      resources :baggages do
        post :approve, on: :member
      end
    end

    get :captain, to: "captain/captains#index"
    namespace :captain do
      resources :drafts, only: [:index, :show]
      resources :games, only: [:index, :show]

      resources :drafted_players, only: [:create] do
        post :create_from_tentative, on: :collection
      end
      resources :tentative_players, only: [:create, :destroy]
    end
  end

  get ":path", to: "pages#page", as: :page
end

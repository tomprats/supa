Supa::Application.routes.draw do
  root to: "pages#summer"

  devise_for :users, controllers: {
    omniauth_callbacks: "authentications",
    registrations: "registrations"
  }

  # Revision 2.0
  resources :teams, only: [:show]
  resources :games, only: [:show] do
    resource :stats, only: [:show]
  end
  get :stats, to: "stats#index"

  get :home, to: "pages#home"
  get :spring, to: "pages#spring"
  get :summer, to: "pages#summer"

  resources :player_awards, only: [:index]

  get  "payments/checkout"
  get  "payments/success"
  post "payments/notify"
  get  "payments/cancel"
  post "payments/credit_card", as: :credit_card
  post "payments/cash",        as: :cash

  devise_scope :user do
    resources :authentications

    get    'drafts/:id/turn',  :to => 'drafts#turn'
    get    'drafts/:id/feed',  :to => 'drafts#feed',
                               :as => 'feed'

    get    'questionnaire',     :to => 'registrations#create_questionnaire'
    get    'questionnaire/:id', :to => 'registrations#questionnaire',
                                :as => 'user_questionnaire'

    # Revision 2.0
    get "sign_in", to: "devise/sessions#new"
    delete "sign_out", to: "devise/sessions#destroy"
    get "register", to: "registrations#register"
    get "unregister", to: "registrations#unregister"
    get "profile", to: "registrations#show"

    get :admin, to: "admin/teams#index"
    namespace :admin do
      resources :teams
      resources :captains
      resources :users
      resources :games do
        resource :stats, only: [:edit, :update]
      end
    end

    get :super, to: "super/announcements#index"
    namespace :super do
      resources :announcements
      resources :leagues do
        get :activate, on: :member
      end
      resources :drafts do
        post :order, on: :member
        post :snake, on: :member
        post :activate, on: :member
      end
      resources :fields
      resources :users, only: [:index, :update] do
        put :assign, on: :collection
        put :trade, on: :collection
      end
    end

    get :captain, to: "captain/captains#index"
    namespace :captain do
      resources :drafts, only: [:index, :show]
    end

    resources :draft_groups
    resources :draft_players
    put "drafted_player/:id", to: "drafted_players#create",
                              as: "drafted_player"
  end
end

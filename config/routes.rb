Supa::Application.routes.draw do
  root to: "pages#summer"

  devise_for :users, :controllers => {
    :omniauth_callbacks => "authentications",
    :registrations      => "registrations"
  }

  get      'home',             :to => 'pages#home'
  get      'spring',           :to => 'pages#spring'
  get      'summer',           :to => 'pages#summer'
  get      'stats',            :to => 'stats#index'

  resources :player_awards, only: [:index]
  resources :teams
  resources :games do
    resource :stats, only: [:show, :edit, :update]
  end
  resources :leagues do
    get "activate", on: :member
  end

  get  "payments/checkout"
  get  "payments/success"
  post "payments/notify"
  get  "payments/cancel"
  post "payments/credit_card", as: :credit_card
  post "payments/cash",        as: :cash

  devise_scope :user do
    resources :authentications
    resources :announcements
    resources :fields
    resources :drafts do
      get 'snake', on: :member
      get 'activate', on: :member
    end

    post   'drafts/:id/order', :to => 'drafts#order',
                               :as => 'draft_order'
    get    'drafts/:id/turn',  :to => 'drafts#turn'
    get    'drafts/:id/feed',  :to => 'drafts#feed',
                               :as => 'feed'
    get    'summer/draft',     :to => 'drafts#feed',
                               :as => 'summer_draft'

    resources :draft_groups
    resources :draft_players

    get    'sign_in',          :to => 'devise/sessions#new'
    delete 'sign_out',         :to => 'devise/sessions#destroy'

    get    'register',         :to => 'registrations#register'
    get    'unregister',       :to => 'registrations#unregister'
    get    'profile',          :to => 'registrations#show'
    get    'team',             :to => 'teams#show'

    get    'super',            :to => 'admins#super'
    get    'admin',            :to => 'admins#standard'
    get    'captain',          :to => 'admins#captain'

    put    'update/admin/:id', :to => 'admins#update_admin',
                               :as => 'update_admin'

    put    'drafted_player/:id', :to => 'drafted_players#create',
                                 :as => 'drafted_player'
    put    'assign_player',      :to => 'admins#assign_player',
                                 :as => 'assign_player'
    put    'trade_players',      :to => 'admins#trade_players',
                                 :as => 'trade_players'

    get    'questionnaire',     :to => 'registrations#create_questionnaire'
    get    'questionnaire/:id', :to => 'registrations#questionnaire',
                                :as => 'user_questionnaire'
  end
end

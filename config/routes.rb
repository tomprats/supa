Supa::Application.routes.draw do
  devise_for :users, :controllers => {
    :omniauth_callbacks => "authentications",
    :registrations      => "registrations"
  }

  get      'home',             :to => 'pages#home'
  get      'spring',           :to => 'pages#spring2014'

  resources :teams
  resources :games

  authenticated :user do
    devise_scope :user do
      root :to => 'devise/sessions#new', :as => "authenticated"

      resources :authentications
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

      post   'update/user/:id',  :to => 'admins#update_user',
                                 :as => 'admin_update_user'

      put    'drafted_player/:id', :to => 'drafted_players#create',
                                   :as => 'drafted_player'

      get    'questionnaire',     :to => 'registrations#create_questionnaire'
      get    'questionnaire/:id', :to => 'registrations#questionnaire',
                                  :as => 'user_questionnaire'
    end
  end

  unauthenticated do
    devise_scope :user do
      root to: "devise/sessions#new", :as => "unauthenticated"
    end
  end
end

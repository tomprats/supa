Supa::Application.routes.draw do
  devise_for :users, :controllers => {
    :omniauth_callbacks => "authentications",
    :registrations      => "registrations"
  }

  get      'home',             :to => 'pages#home'

  authenticated :user do
    devise_scope :user do
      resources :authentications

      root :to => 'devise/sessions#new', :as => "authenticated"

      get    'sign_in',          :to => 'devise/sessions#new'
      get    'sign_out',         :to => 'devise/sessions#destroy'
      delete 'sign_out',         :to => 'devise/sessions#destroy'
      delete 'users/sign_out',   :to => 'devise/sessions#destroy'

      get    'profile',          :to => 'registrations#show'
    end
  end

  unauthenticated do
    devise_scope :user do
      root to: "devise/sessions#new", :as => "unauthenticated"
    end
  end
end

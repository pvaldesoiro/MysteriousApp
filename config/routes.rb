Rails.application.routes.draw do
  root 'pages#home'

  devise_for :users, controllers: { sessions: 'sessions',
                                    registrations: 'registrations' }

  resources :articles, only: [:index, :create, :update, :destroy] do
    resources :comments, only: [:index, :create, :update, :destroy]
  end
end

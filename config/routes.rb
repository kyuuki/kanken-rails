Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#index'

  get 'start', to: 'welcome#start'

  resources :cards, only: [:show] do
    member do
      get 'answer'
      get 'action'
    end
  end

  devise_for :users,
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }

  # 管理画面

  # https://www.tmp1024.com/programming/post-4661
  devise_for :admin_users,
             path: 'admin',
             only: [:sign_in, :sign_out, :session],
             controllers: {
               sessions: 'admin_users/sessions'
             }

  namespace 'admin' do
    root to: 'welcome#index'
    resources :cards
    resources :users
    resources :clients
    resources :admin_users, only: [:index]
  end
end

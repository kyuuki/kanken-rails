Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#index'

  get 'start', to: 'welcome#start'

  resources :cards, only: [ :show ] do
    member do
      get 'answer'
      get 'action'
    end
  end

  # 管理画面

  # https://www.tmp1024.com/programming/post-4661
  devise_for :admin_users, path: 'admin/users'

  namespace 'admin' do
    root to: 'welcome#index'
    resources :cards
    resources :clients
  end
end

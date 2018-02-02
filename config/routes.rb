Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#index'

  resources :cards, only: [ :show ] do
    member do
      get 'answer'
      get 'action'
    end
  end

  # 管理画面
  namespace 'admin' do
    root to: 'welcome#index'
    resources :cards
  end
end

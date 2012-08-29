Gitcup::Application.routes.draw do
  devise_for :users

  root :to => 'welcome#index'

  namespace :api, defaults: { format: 'json' } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do

      resources :users, only: :me do
        get 'me', on: :collection
      end

      resources :tokens, only: [:create, :destroy]

    end
  end
end

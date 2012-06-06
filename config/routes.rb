Frog::Application.routes.draw do


  resources :projects do
    resources :members
    resources :versions do
      post 'release', :on => :member
    end
    get 'set_cv', :on => :member
  end
  resources :jobs do
    resources :changelogs

    post 'update_status', :on => :member
    post 'audit',         :on => :member
  end
  resources :preconditions
  resources :relavants
  resources :audits

  devise_for :users
  resources :users

  root :to => 'projects#index'

end

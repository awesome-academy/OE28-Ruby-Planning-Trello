Rails.application.routes.draw do
  devise_for :users, only: :omniauth_callbacks, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}

  mount API::Base, at: "/"

  scope "(:locale)", locale: /en|vi/ do
    require "sidekiq/web"
    mount Sidekiq::Web => "/sidekiq"

    root "static_pages#home"

    devise_for :users, skip: :omniauth_callbacks, controllers: {
      registrations: "users/registrations",
      confirmations: "users/confirmations",
      sessions: "users/sessions",
      passwords: "users/passwords"
    }

    devise_scope :user do
      get "/sign_up", to: "registrations#new"
      get "/sign_in", to: "sessions#new"
      get "/recover_password", to: "passwords#new"
    end

    resources :users, only: :show do
      resources :activities, only: :index
      resources :closed, only: :index
    end

    resources :boards do
      resource :tag_labels, only: %i(create edit destroy)
      post "labels/create", to: "labels#create", as: "create_label"
      patch "labels/:id", to: "labels#update", as: "update_label"
      delete "labels/:id", to: "labels#destroy", as: "destroy_label"

      resources :tags, except: %i(index show new) do
        resources :checklists, only: %i(create update destroy) do
          patch "/checked", on: :member, to: "checked_checklists#update"
        end

        resource :deadline, only: %i(create update destroy)

        post "/join", on: :member, to: "join_tags#create"
        delete "/leave", on: :member, to: "join_tags#destroy"

        post "/close", on: :member, to: "close_tags#create"
        delete "/open", on: :member, to: "close_tags#destroy"

        resources :attachments, only: %i(create update destroy)
      end
      patch "sort/tags", to: "sortable_tags#update", as: "sort_tags"

      resource :tag_users, only: %i(create edit destroy)
      resources :user_boards, only: :update
    end

    patch "/status", to: "boards#update_board_status", as: "status"
    patch "/close", to: "boards#update_board_closed", as: "board_closed"
    resources :lists, only: %i(create update destroy)
    resources :add_members, only: %i(new edit)
    patch "list/changeposition", to: "lists#change_position", as: "position_list"
    patch "list/closed", to: "lists#closed_list", as: "closed_list"

    resources :search, only: :index

    match "*unmatched", to: "application#rescue_404_exception", via: :all
  end
end

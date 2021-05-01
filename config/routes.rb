# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :my do
    resources :thoughts, only: [:index]

    resources :works, only: [:index]
  end

  post :telegram, to: "telegram#accept_message"

  root "application#index"
end

Rails.application.routes.draw do

  get 'new', to: 'games#new', as: :new
  get 'score', to: 'games#score', as: :score
  post 'score', to: 'games#score'

  # get 'questions/ask'
  # get 'questions/answer'
  # get 'games/new'
  # get 'games/score'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

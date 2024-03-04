Rails.application.routes.draw do
  # Define suas rotas aqui

  # Reveal health status on /up that retorna 200 se o aplicativo inicializar sem exceções, caso contrário, retorna 500.
  # Pode ser usado por balanceadores de carga e monitores de tempo de atividade para verificar se o aplicativo está ativo.
  # get "up" => "rails/health#show", as: :rails_health_check

  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy]
  resources :movies, only: [:index, :new, :create]
  resources :user_movies, only: [:create, :update]

  get '/login', to: 'sessions#new'
  get '/import_movies', to: 'import_movies#index'
  get '/import_comments', to: 'import_comments#index'

  post '/import_movies', to: 'import_movies#process_file'
  post '/import_movies/process_file', to: 'import_movies#process_file'

  # Rota para submeter notas em massa para vários filmes
  post '/import_comments', to: 'import_comments#import_grades'

  delete '/logout', to: 'sessions#destroy'

  root 'sessions#new'
end

Rails.application.routes.draw do
  #devise_for :users
  devise_for :users, controllers: { registrations: "registrations"}
  mount ActionCable.server => '/cable'
  root to: redirect(path: '/scans')

  get '/scans' => 'pages#scans'
  get 'notifications/new'

  # index ever used, ever?
  resources :groups, only: %i[create new]

  post 'groups/group' => 'groups#group', as: :single_group_html

  post 'groups/create_form' => 'groups#create_form'

  post 'groups/copy_form' => 'groups#copy_form'
  post 'groups/copy' => 'groups#copy'

  post 'groups/move_form' => 'groups#move_form'
  post 'groups/move' => 'groups#move'

  post 'groups/export_form' => 'groups#export_form'
  post 'groups/export' => 'groups#export'

  post 'groups/delete_form' => 'groups#delete_form'
  post 'groups/delete' => 'groups#delete'

  post 'groups/delete_clients_form' => 'groups#delete_clients_form'
  post 'groups/delete_clients' => 'groups#delete_clients'

  post 'groups/scan_form' => 'groups#scan_form'

  get 'groups/refresh' => 'groups#refresh', as: :group_refresh

  get '/groups' => 'groups#index'
  get '/pages/settings' => 'pages#settings', as: :global_settings
  get '/pages/changelog' => 'pages#changelog', as: :changelog
  post '/clients/global_search' => 'clients#global_search', as: :global_search

  get '/clients/search' => 'clients#search'
  post '/clients/search' => 'clients#search', as: :global_search_view
  #
  # order matters. keep this below other clients-routes, or it will always match.
  # alternatively, constraints need to be used (ie. regex for \d etc)
  get '/clients' => 'clients#index'
  get '/clients/:id' => 'clients#show'

  post 'setting/update_user_settings' => 'setting#update_user_settings', as: :update_user_settings
  post 'settings/update' => 'settings#update', as: :update_settings

  post 'scans/create' => 'scans#create'
  get 'scans/reload_status' => 'scans#reload_status'
  get 'scans/reload_finished' => 'scans#reload_finished'
  post 'scans/upload' => 'scans#upload'
  post 'scans/download' => 'scans#download', as: :download_scan

  resources :clients
end
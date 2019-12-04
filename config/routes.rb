require 'sidekiq/web'

Rails.application.routes.draw do
  resources :issue_groups
  resources :issues
  resources :screenshots, only: [:edit, :update, :destroy]
  resources :reports
  resources :clients
  devise_for :users, controllers: { registrations: "registrations", sessions: "sessions"}
  mount ActionCable.server => '/cable'
  root to: redirect(path: '/scans')

  get '/scans' => 'pages#scans'

  resources :issue_templates
  post '/issue_templates/search' => 'issue_templates#search', as: :issue_templates_search
  post '/issue_templates/search_add' => 'issue_templates#search_add', as: :issue_templates_search_add

  post '/reports/change_parent' => 'reports#change_parent', as: :change_parent
  match '/reports/:id/export_docx' => 'reports#export_docx', as: :export_odt, via: [:get, :post]

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
  get 'groups/group_list' => 'groups#group_list', as: :group_list

  get '/groups' => 'groups#index'
  get '/pages/settings' => 'pages#settings', as: :global_settings
  get '/pages/changelog' => 'pages#changelog', as: :changelog
  post '/clients/global_search' => 'clients#global_search', as: :global_search

  get '/images' => 'images#index', as: :images
  get '/images/scan_all' => 'images#scan_all', as: :images_scan_all
  get '/images/scan_all_overwrite' => 'images#scan_all_overwrite', as: :images_scan_all_overwrite

  get '/clients/search' => 'clients#search'
  post '/clients/search' => 'clients#search', as: :global_search_view
  #
  # order matters. keep this below other clients-routes, or it will always match.
  # alternatively, constraints need to be used (ie. regex for \d etc)
  get '/clients' => 'clients#index'
  get '/clients/:id' => 'clients#show'
  post '/clients/archive' => 'clients#archive', as: :clients_archive
  post '/clients/unarchive' => 'clients#unarchive', as: :clients_unarchive
  get '/clients/:id/new_issue_form' => 'clients#new_issue_form', as: :clients_new_issue_form
  get '/clients/:id/link_issue_form' => 'clients#link_issue_form', as: :clients_link_issue_form
  get '/clients/:id/link_issue/:issue' => 'clients#link_issue', as: :clients_link_issue

  post 'setting/update_user_settings' => 'setting#update_user_settings', as: :update_user_settings
  post 'settings/update' => 'settings#update', as: :update_settings

  post 'scans/create' => 'scans#create'
  post 'scans/upload' => 'scans#upload'
  post 'scans/download' => 'scans#download', as: :download_scan
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end
end
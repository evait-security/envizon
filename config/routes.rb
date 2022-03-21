require 'sidekiq/web'

Rails.application.routes.draw do
  resources :notes, only: [:create, :destroy]
  resources :issue_groups
  resources :issues
  resources :screenshots, only: [:edit, :update, :destroy]
  resources :reports
  resources :clients
  resources :issue_templates
  devise_for :users, controllers: { registrations: "registrations", sessions: "sessions"}
  mount ActionCable.server => '/cable'
  root to: redirect(path: '/scans/new')

  get '/scans/new' => 'scans#new', as: :new_scan
  get "/notes/new/:noteable_type/:noteable_id" => 'notes#new', as: :new_note
  get '/issue_templates/create_from_issue/:issue_id' => 'issue_templates#create_from_issue', as: :issue_template_create_from_issue
  post '/issue_templates/search' => 'issue_templates#search', as: :issue_templates_search
  post '/issue_templates/search_add' => 'issue_templates#search_add', as: :issue_templates_search_add

  get '/reports/:id/change_parent/:source/:new_parent' => 'reports#change_parent', as: :change_parent
  match '/reports/:id/export_docx' => 'reports#export_docx', as: :export_odt, via: [:get, :post]
  match '/reports/:id/export_xlsx' => 'reports#export_xlsx', as: :export_xlsx, via: [:get, :post]
  match '/reports/:id/export_verinice' => 'reports#export_verinice', as: :export_verinice, via: [:get, :post]

  # index ever used, ever?
  resources :groups, only: %i[create new]

  post '/groups/group' => 'groups#group', as: :single_group_html

  post '/groups/create_form' => 'groups#create_form'

  post '/groups/copy_form' => 'groups#copy_form'
  post '/groups/copy' => 'groups#copy'

  post '/groups/move_form' => 'groups#move_form'
  post '/groups/move' => 'groups#move'

  post '/groups/export_form' => 'groups#export_form'
  post '/groups/export' => 'groups#export'

  post '/groups/delete_form' => 'groups#delete_form'
  post '/groups/delete' => 'groups#delete'

  post '/groups/delete_clients_form' => 'groups#delete_clients_form'
  post '/groups/delete_clients' => 'groups#delete_clients'

  post '/groups/scan_form' => 'groups#scan_form'

  get '/groups/refresh' => 'groups#refresh', as: :group_refresh
  get '/groups/group_list' => 'groups#group_list', as: :group_list

  get '/issues/:id/update_template' => 'issues#update_template', as: :update_template
  get '/issues/:id/new_template' => 'issues#new_template', as: :new_template
  get '/issues/:id/confirm_update_template' => 'issues#confirm_update_template', as: :confirm_update_template
  get '/issues/:id/confirm_create_template' => 'issues#confirm_create_template', as: :confirm_create_template
  get '/issues/:id/link_client_form' => 'issues#link_client_form', as: :issue_link_clients_form
  get '/issues/:id/link_client/:client' => 'issues#link_client', as: :issue_link_clients

  get '/groups' => 'groups#index'
  get '/pages/settings' => 'pages#settings', as: :global_settings

  get '/images' => 'images#index', as: :images
  get '/images/scan_all' => 'images#scan_all', as: :images_scan_all
  get '/images/scan_all_overwrite' => 'images#scan_all_overwrite', as: :images_scan_all_overwrite
  post '/images/scan_custom_overwrite' => 'images#scan_custom_overwrite', as: :scan_custom_overwrite

  get '/clients/search/form' => 'clients#search_form', as: :global_search_view
  post '/clients/global_search' => 'clients#global_search', as: :global_search
  post '/clients/archive' => 'clients#archive', as: :clients_archive
  post '/clients/unarchive' => 'clients#unarchive', as: :clients_unarchive
  get '/clients/:id/new_issue_form' => 'clients#new_issue_form', as: :clients_new_issue_form
  get '/clients/:id/link_issue_form' => 'clients#link_issue_form', as: :clients_link_issue_form
  get '/clients/:id/link_issue/:issue' => 'clients#link_issue', as: :clients_link_issue
  get '/clients/:id/unlink_issue/:issue' => 'clients#unlink_issue', as: :clients_unlink_issue

  post 'setting/update_user_settings' => 'setting#update_user_settings', as: :update_user_settings
  post 'settings/update' => 'settings#update', as: :update_settings

  post '/scans/create' => 'scans#create'
  post '/scans/upload' => 'scans#upload'
  post '/scans/download' => 'scans#download', as: :download_scan

  get '/methodologies' => 'methodologies#index', as: :methodologies_index
  get '/methodologies/book/:id' => 'methodologies#book', as: :methodologies_book
  get '/methodologies/:id/check' => 'methodologies#check', as: :methodologies_check
  get '/methodologies/:id' => 'methodologies#show', as: :methodologies_show

  post '/placeholder_set/create' => 'placeholder#create', as: :placeholder_set_create
  get '/placeholder_set/:id/select' => 'placeholder#select', as: :placeholder_set_select
  get '/placeholder_set/:id/destroy' => 'placeholder#destroy', as: :placeholder_set_destroy

  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end
end

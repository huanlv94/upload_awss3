Rails.application.routes.draw do

  root 'uploads#new'
  get 'uploads/new'
  post 'uploads/new'

  get 'uploads/create'
  post 'uploads/create'

  get 'uploads/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :uploads, path: '/uploads' do
    collection do
      get 'image', to: 'uploads#view_image'
      get 'audio', to: 'uploads#listen_audio'
      get 'document', to: 'uploads#document'
    end
  end
end

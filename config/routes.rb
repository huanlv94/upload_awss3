Rails.application.routes.draw do

  mount ActionCable.server => '/cable'

  # root 'uploads#new'

  get 'uploads/new'
  post 'uploads/new'

  get 'uploads/create'
  post 'uploads/create'

  get 'uploads/index'
  post 'uploads/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :uploads, path: '/uploads' do
    collection do
      get '/', to: 'uploads#new'
      post '/', to: 'uploads#new'
      get 'video', to: 'uploads#video'
      get 'image', to: 'uploads#view_image'
      get 'audio', to: 'uploads#listen_audio'
      get 'document', to: 'uploads#document'
      get 'fake_broadcast', to: 'uploads#fake_broadcast'
      post 'update_job', to: 'uploads#update_job'
    end
  end
end

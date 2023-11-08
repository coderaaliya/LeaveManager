Rails.application.routes.draw do
  resources :leaves
  get 'leaves/leave_details/:id', to: 'leaves#leave_details', as: 'leave_details'
  get 'employees/edit'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
    root "employees#index"
   resources :employees, only: [:edit, :update, :index]
   resources :employees 
  resources :leaves do
     member do
      
      put 'approve'
      put 'reject'
    end
  end

end

Rails.application.routes.draw do


  resources :courses, only: [:index, :show] do

    post '/add_to_courses' => 'courses#add_to_courses'
    delete '/remove_from_courses' => 'courses#remove_from_courses'

    resources :chapters, only: [:index, :show] do
      resources :challenges, only: [:index, :show] do
        post 'check_validation' => 'challenges#check_validation'
        get 'hints/:hint_id' => "challenges#get_hint"
        get 'get_next_hint' => "challenges#get_next_hint"
      end
    end
  end

  get '/my_courses' => 'courses#user_courses'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users
  get '/profile' => 'profiles#show'
  get '/profile/edit' => 'profiles#edit'

  root "pages#home"

  # get '/contact-us' => 'pages#contact_us'
  get '/about-us' => 'pages#about_us'
  get '/restaurant_css_game' => 'pages#restaurant_css_game'



  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

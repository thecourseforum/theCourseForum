TheCourseForum::Application.routes.draw do
  root :to => 'welcome#index'

  # Routes for user authentication
  devise_for :users, :controllers => {
    :registrations => "registrations", 
    :sessions => "sessions", 
    :confirmations => "confirmations"}

  devise_scope :user do
    get '/student_sign_up', :to => "registrations#student_sign_up", :as => "student_sign_up"
    # get '/professor_sign_up', :to => "registrations#professor_sign_up", :as => "professor_sign_up"
  end

  resources :reviews, :only => [:new, :create, :edit, :update]

  resources :students, :only => [:create]

  resources :course_professors, :only => [:index]

  resources :professors, :only => [:index, :show]

  resources :courses, :only => [:show]

  get '/scheduler/manual' => 'scheduler#manual'
  get '/scheduler/automatic' => 'scheduler#automatic'
  get '/scheduler/search_sections' => 'scheduler#search_sections'
  get '/scheduler/search_course' => 'scheduler#search_course'
  get '/scheduler/schedules' => 'scheduler#schedules'
  get '/scheduler/sections' => 'scheduler#sections'
  get 'scheduler/saved_selections' => 'scheduler#saved_selections'
  post '/scheduler/course' => 'scheduler#save_course'
  post '/scheduler/sections' => 'scheduler#save_sections'
  post '/scheduler/save_selections' => 'scheduler#save_selections'
  delete '/scheduler/courses' => 'scheduler#clear_courses'

  resources :departments, :only => [:show, :index]
 
  resources :search, :only => [] do
    collection do
      get :search
    end
  end

  get '/browse', :to => 'departments#index', :as => "browse"

  get '/contact_us', :to => 'contact_us#new', :as => "contact_us"

  post '/contact_us/submit', :to => 'contact_us#submit', :as => "submit_report"

  get '/my_reviews', :to => 'reviews#index', :as => 'my_reviews'

  get '/about', :to => 'home#about', :as => "about"
  get '/privacy', :to => 'home#privacy', :as => "privacy"
  get '/terms_of_use', :to => 'home#terms', :as => "terms"

  # route for user settings
  get '/users/settings', :to => "users#settings", :as => "user_settings"

  post '/word_cloud_on', :to => "users#word_cloud_on"
  post '/word_cloud_off', :to => "users#word_cloud_off"
  post '/doge_on', :to => "users#doge_on"
  post '/doge_off', :to => "users#doge_off"


  #routes for voting
  post '/vote_up/:review_id', :to => 'reviews#vote_up'
  post '/vote_down/:review_id', :to => 'reviews#vote_down'


  authenticated :user do
    root :to => redirect("/browse"), :as => :authenticated_root
  end
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

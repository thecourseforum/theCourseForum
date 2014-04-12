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

  get '/scheduler' => 'scheduler#ui'

  get '/scheduler/search' => 'scheduler#search'

  resources :departments, :only => [:show, :index]

  resources :subdepartments, :only => [:show]
 
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

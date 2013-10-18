TheCourseForum::Application.routes.draw do
  root :to => 'welcome#index'

  # Routes for user authentication
  devise_for :users, :controllers => {
    :registrations => "registrations", 
    :sessions => "sessions", 
    :confirmations => "confirmations"}

  devise_scope :user do
    get '/student_sign_up', :to => "registrations#student_sign_up", :as => "student_sign_up"
    get '/professor_sign_up', :to => "registrations#professor_sign_up", :as => "professor_sign_up"
  end

  #resources :grades

  #resources :semesters

  resources :reviews, :only => [:new, :create]

  #resources :student_majors

  #resources :majors

  resources :students, :only => [:create, :index]

  # resources :users, :only => [:create, :index]

  # resources :sessionsrequest.fullpath

  resources :course_professors, :only => [:index, :show]

  resources :professors, :only => [:index, :show]

  resources :courses, :only => [:show]

  #resources :schools

  resources :subdepartments, :only => [:show]

  resources :departments, :only => [:show, :index]

  resources :home
 
  resources :search do
    collection do
      get :search
    end
  end

  get '/browse', :to => 'departments#index', :as => "browse"

  get '/error_report', :to => 'error_reports#new', :as => "new_error_report"

  post '/error_report/submit', :to => 'error_reports#submit', :as => "submit_error_report"

  get '/myreviews', :to => 'reviews#index', :as => 'my_reviews'

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

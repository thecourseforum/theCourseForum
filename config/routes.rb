TheCourseForum::Application.routes.draw do
  root :to => 'welcome#index'

  # Routes for user authentication
  get "login" => "sessions#new", :as => "login"
  post "login" => "sessions#create", :as => "login"
  get "logout" => "sessions#destroy", :as => "logout"

  #resources :grades

  #resources :semesters

  resources :reviews, :only => [:new, :index]

  #resources :student_majors

  #resources :majors

  resources :students, :only => [:create, :index]

  resources :users, :only => [:create, :index]

  resources :sessions

  resources :course_professors, :only => [:show]

  #resources :professors

  resources :courses, :only => [:show]

  #resources :schools

  #resources :subdepartments

  resources :departments, :only => [:show, :index]

  resources :home
 
  resources :search do
    collection do
      get :search
    end
  end

  match '/browse', to: 'departments#index'
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.

  #when using warden/devise
  #root to: "home#index", constraints: lambda { |r| r.env["warden"].authenticate? }
  #root to: "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end

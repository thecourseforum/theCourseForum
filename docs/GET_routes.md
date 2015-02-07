
                          root GET    /                                     welcome#index
              new_user_session GET    /users/sign_in(.:format)              sessions#new
             new_user_password GET    /users/password/new(.:format)         devise/passwords#new
            edit_user_password GET    /users/password/edit(.:format)        devise/passwords#edit
      cancel_user_registration GET    /users/cancel(.:format)               registrations#cancel
         new_user_registration GET    /users/sign_up(.:format)              registrations#new
        edit_user_registration GET    /users/edit(.:format)                 registrations#edit
         new_user_confirmation GET    /users/confirmation/new(.:format)     confirmations#new
                               GET    /users/confirmation(.:format)         confirmations#show
               student_sign_up GET    /student_sign_up(.:format)            registrations#student_sign_up
                    new_review GET    /reviews/new(.:format)                reviews#new
                   edit_review GET    /reviews/:id/edit(.:format)           reviews#edit
             course_professors GET    /course_professors(.:format)          course_professors#index
                    professors GET    /professors(.:format)                 professors#index
                     professor GET    /professors/:id(.:format)             professors#show
                        course GET    /courses/:id(.:format)                courses#show
              scheduler_manual GET    /scheduler/manual(.:format)           scheduler#manual
           scheduler_automatic GET    /scheduler/automatic(.:format)        scheduler#automatic
     scheduler_search_sections GET    /scheduler/search_sections(.:format)  scheduler#search_sections
       scheduler_search_course GET    /scheduler/search_course(.:format)    scheduler#search_course
           scheduler_schedules GET    /scheduler/schedules(.:format)        scheduler#schedules
            scheduler_sections GET    /scheduler/sections(.:format)         scheduler#sections
    scheduler_saved_selections GET    /scheduler/saved_selections(.:format) scheduler#saved_selections
                   departments GET    /departments(.:format)                departments#index
                    department GET    /departments/:id(.:format)            departments#show
           search_search_index GET    /search/search(.:format)              search#search
                        browse GET    /browse(.:format)                     departments#index
                    contact_us GET    /contact_us(.:format)                 contact_us#new
                    my_reviews GET    /my_reviews(.:format)                 reviews#index
                         about GET    /about(.:format)                      home#about
                       privacy GET    /privacy(.:format)                    home#privacy
                         terms GET    /terms_of_use(.:format)               home#terms
                 user_settings GET    /users/settings(.:format)             users#settings
            authenticated_root GET    /                                     redirect(301, /browse)

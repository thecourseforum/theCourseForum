# This method signs in a user when testing outside of controllers and views.
# Mostly used for features. 

def sign_in_user(user)
   user.confirm!
   visit new_user_session_path
   fill_in "Email",    with: user.email
   fill_in "Password", with: user.password
   click_button "Sign in"
end
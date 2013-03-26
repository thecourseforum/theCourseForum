# Be sure to restart your server when you modify this file.

TheCourseForum::Application.config.session_store :cookie_store, key: '_theCourseForum_session', expire_after: 504.hours

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# TheCourseForum::Application.config.session_store :active_record_store

#Include Devise test helpers for controllers and views.

require 'devise'

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.include Devise::TestHelpers, :type => :view
end
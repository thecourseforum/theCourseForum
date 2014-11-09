# RSpec
# spec/support/factory_girl.rb
# Allows for FactoryGirl calls to be done with Class Prefix
# FactoryGirl.create(:user) => create(:user)
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
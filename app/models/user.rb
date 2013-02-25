class User < ActiveRecord::Base
  belongs_to :student
  belongs_to :professor
  attr_accessible :email, :last_login, :old_password, :password_crypt, :subscribed_to_email
end

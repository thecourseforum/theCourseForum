class User < ActiveRecord::Base
  belongs_to :student
  belongs_to :professor
  attr_accessible :email, :last_login, :old_password, :password_crypt, :subscribed_to_email
  validates :email, presence: true
  validates :old_password, presence: true
  validates :old_password_confirmation, presence: true
  validates_confirmation_of :old_password
end

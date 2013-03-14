class User < ActiveRecord::Base
  has_secure_password

  belongs_to :student
  belongs_to :professor

  attr_accessible :email, :last_login, :old_password, :password, :password_confirmation, :subscribed_to_email

  before_save { self.email.downcase! }
  VALID_EMAIL_REGEX = /\A[\w\-\.]+@(\w+\.)*virginia\.edu\z/i

  validates :email, :presence   => true,
                    :format     => { :with => VALID_EMAIL_REGEX },
                    :uniqueness => { :case_sensitive => false }
  validates_presence_of :password
  validates_presence_of :password_confirmation

end

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

  def old_authenticate(password)
    password_salt = 'I am a uva student'
    old_hash = Digest::MD5.hexdigest(password + password_salt)
    if old_hash == self.old_password
      return self
    else
      return false
    end
  end

end

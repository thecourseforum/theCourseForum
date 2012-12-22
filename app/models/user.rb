# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  graduation :integer
#  major1     :string(255)
#  major2     :string(255)
#  major3     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
#  attr_accessor :password
  attr_accessible :email, :graduation, :major1, :major2, :major3, :name, :password_confirmation, :password
  has_secure_password

  before_save { |user| user.email = email.downcase }

  validates :name, :presence => true, :length => { :maximum => 50 }
#  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_EMAIL_REGEX = /\A[A-Za-z0-9._%+-]+@([A-Za-z0-9._%+-]+\.)?(virginia.edu)/i
  validates :email, :presence => true, :format => { :with => VALID_EMAIL_REGEX },
  :uniqueness => { :case_sensitive => false }
  validates :password, :presence => true,
  :length => { :minimum => 6 }
  validates :password_confirmation, :presence => true
  
  
end

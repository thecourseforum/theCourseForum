class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :email, :graduation, :major1, :major2, :major3, :name, :password_confirmation
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..100 }
  
end

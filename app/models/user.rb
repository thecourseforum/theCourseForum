class User < ActiveRecord::Base
  attr_accessible :email, :graduation, :major1, :major2, :major3, :name
end

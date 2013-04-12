class Professor < ActiveRecord::Base
  belongs_to :department
  belongs_to :user
  attr_accessible :email_alias, :first_name, :last_name, :preferred_name
  has_many :sections, :through => :section_professors
end

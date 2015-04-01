class Bug < ActiveRecord::Base
	validates :content, presence: true
end

class User < ActiveRecord::Base
	has_many :thoughts, dependent: :destroy
end
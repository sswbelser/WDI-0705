class User < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  has_secure_password

  validates :password, length: { minimum: 6 }, on: :create

  validates :email,
    presence: true,
    uniqueness: true,
    format: {
      with: /@/,
      message: "not a valid format"
    }

end
class User < ApplicationRecord
  has_secure_password validations: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }

  has_many :tweets
end

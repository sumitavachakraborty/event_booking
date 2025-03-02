class Customer < ApplicationRecord
    has_secure_password
    
    has_many :bookings, dependent: :destroy
    
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :password_digest, presence: true
end
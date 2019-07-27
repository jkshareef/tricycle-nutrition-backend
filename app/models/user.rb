class User < ApplicationRecord
    has_secure_password
    validates :username, uniqueness: {case_sensitive: false}

    has_many :meals, dependent: :destroy
end

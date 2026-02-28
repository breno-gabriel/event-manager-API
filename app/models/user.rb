class User < ApplicationRecord
    has_secure_password
    validates :email, presence: true, uniqueness: true

    def as_json(options = {})
        super(options.merge(except: [:password_digest]))
    end

end

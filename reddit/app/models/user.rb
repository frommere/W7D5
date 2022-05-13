class User < ApplicationRecord
    validates :username, presence:true, uniqueness:true
    validates :password_digest, presence:true
    validates :password, length: {minimum:6}, allow_nil:true
    attr_reader :password
    after_initialize :ensure_session_token

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        return nil if user.nil?
        user.is_password?(password) ? user : nil
    end
    def password=(password)
        self.password_digest = BCrypt::Password.create(password)
        @password = password
    end
    def is_password?(password)
        user_object = BCrypt::Password.new(self.password_digest)
        user_object.is_password?(password)
    end
    def reset_session_token!
        self.session_token = SecureRandom::urlsafe_base64
        self.save!
        self.session_token
    end
    def ensure_session_token
        self.session_token ||= SecureRandom::urlsafe_base64
    end


end
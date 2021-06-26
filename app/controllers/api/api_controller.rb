class Api::ApiController < ActionController::Base
  # skip_before_action :verify_authenticity_token
  before_action :set_csrf_cookie
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection

  protect_from_forgery with: :exception
  include SessionsHelper
  private
    def set_csrf_cookie
      cookies["CSRF-TOKEN"] = form_authenticity_token
    end
    def encode_token(payload)
      JWT.encode(payload, 'my_secret')
    end
    def auth_header
      request.headers['Authorization']
    end
    def decoded_token
      if auth_header
        token = auth_header.split(' ')[1]
        begin
          JWT.decode(token, 'my_secret', true, algorithm: 'HS256')
        rescue JWT::DecodeError
          []
        end
      end
    end
    def session_user
      decoded_hash = decoded_token
      if !decoded_hash.empty? 
        puts decoded_hash.class
        user_id = decoded_hash[0]['user_id']
        @user = User.find_by(id: user_id)
      else
        nil 
      end
    end
    def jwt_logged_in?
      !!session_user
    end
    # Confirms a logged-in user.
    def logged_in_user
      unless jwt_logged_in?
        render json: { flash: ["danger", "Please log in."] }, status: :unauthorized
      end
    end
end

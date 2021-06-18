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
    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        render json: { flash: ["danger", "Please log in."] }
      end
    end
end

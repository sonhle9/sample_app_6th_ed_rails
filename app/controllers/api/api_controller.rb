class Api::ApiController < ActionController::Base
  skip_before_action :verify_authenticity_token
  include SessionsHelper
  private
    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        render json: { flash: ["danger", "Please log in."] }
      end
    end
end

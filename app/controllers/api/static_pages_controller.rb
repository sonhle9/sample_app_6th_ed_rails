class Api::StaticPagesController < Api::ApiController
  def home
    if jwt_logged_in?
      @feed_items = current_user.feed.page(params[:page])
    else
      head :ok
    end
  end
end

class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      @unread_count = current_user.unread_messages_count
      if params[:q]
        @feed_items = Micropost.search_by_keyword(params[:q])
                               .page(params[:page])
      else
        @feed_items = current_user.feed.page(params[:page])
      end
    else
      if params[:q]
        @feed_items = Micropost.search_by_keyword(params[:q])
                               .page(params[:page])
      else
        @feed_items = Micropost.includes(:user).page(params[:page])
      end
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end

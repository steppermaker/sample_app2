class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def show
    @micropost = Micropost.find(params[:id])
    unless  @micropost.replies.blank?
      @replies = @micropost.replies.includes(:user).k_page(params[:page])
    end
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)

    if destination_id = params[:destination_id]
      @destination = Micropost.find(destination_id)
      if @micropost.save
        @destination.add_reply(@micropost)
        flash[:seccess] = "Micropost created!"
        redirect_to @destination
      else
        redirect_to @destination
      end
    else
      if @micropost.save
        flash[:success] = "Micropost created!"
        redirect_to root_url
      else
        @feed_items = []
        render 'static_pages/home'
      end
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_back(fallback_location: root_url)
  end

  def likes
    @micropost = Micropost.find(params[:id])
    @like_users = @micropost.like_users.k_page(params[:page])
    render 'micropost_likes'
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end

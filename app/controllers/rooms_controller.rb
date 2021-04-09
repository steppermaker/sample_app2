class RoomsController < ApplicationController
  before_action :logged_in_user
  before_action :only_mutual_follow_users, only: :create

  def show
    @room = Room.find(params[:id])
    if Entry.where(user_id: current_user.id, room_id: @room.id).exists?
      @talk_to = @room.talking_user(current_user)
      if current_user.mutual_follow?(@talk_to)
        @messages = @room.messages.includes(:user).page(params[:page]).per(5)
        if @messages.total_pages < params[:page].to_i
          @page = "last"
        else
          @page = params[:page].to_i + 1
        end
        respond_to do |format|
          format.html {
            @room.toggle_read(current_user)
            @message  = Message.new
           }
          format.js
        end
      else
        redirect_to root_url
      end
    end
  end

  def create
    @room = Room.create
    @entry = Entry.create(room_id: @room.id, user_id: current_user.id)
    @entry = Entry.create(room_id: @room.id, user_id: @user.id)
    redirect_to @room
  end

  private

    def only_mutual_follow_users
      @user = User.find(params[:user_id])
      redirect_to(root_url) and return if current_user?(@user)
      redirect_to(root_url) unless current_user.mutual_follow?(@user)
    end
end

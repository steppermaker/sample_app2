class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    room_switch(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    room_switch(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  private
  def room_switch(user)
    unless current_user?(user)
      if current_user.mutual_follow?(user)
        current_user_entries = current_user.entries
        user_entries = user.entries
        current_user_entries.each do |cu|
          user_entries.each do |u|
            if cu.room_id == u.room_id
              @is_room = true
              @room_id = cu.room.id
              break
            end
          end
          break if @is_room == true
        end
        unless @is_room
          @entry = Entry.new
          @room = Room.new
        end
      end
    end
  end
end

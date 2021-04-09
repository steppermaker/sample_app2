class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :update, :destroy,
                                        :following, :followers,
                                        :new_messages, :likes]
  before_action :correct_user,   only: [:edit, :update, :new_messages,
                                        :likes]
  before_action :admin_user,     only: :destroy

  def index
    if params[:q]
      @users = User.search_by_keyword(params[:q]).k_page(params[:page])
    else
      @users = User.where(activated: true).k_page(params[:page])
    end
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.includes(:user).k_page(params[:page])
    if logged_in?
      room_switch(@user)
      @unread_count = current_user.unread_messages_count if current_user?(@user)
    end
    redirect_to root_url and return unless @user.activated?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def update
    case params[:change]
    when "profile"
      update_user("profile", @user, user_params_for_profile_update)
    when "name"
      update_user("name", @user, user_params_for_name_update)
    when "email"
      update_user("email", @user, user_params_for_email_update)
    when "password"
      update_user("password", @user, user_params_for_password_update,
                  :current_password)
    else
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy_rooms if @user.entries.present?
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.k_page(params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.k_page(params[:page])
    render 'show_follow'
  end

  def unread_messages
    @messages = current_user.unread_messages.select(:room_id, :user_id)
                            .distinct.k_page(params[:page])
    render 'show_unread_message_rooms'
  end

  def likes
    @microposts = @user.likes_microposts.includes(:user).k_page(params[:page])
    render 'favorite_microposts'
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation,
                                   :unique_name)
    end

    def user_params_for_profile_update
      params.require(:user).permit(:profile, :password, :password_confirmation)
                                  .merge(password_confirmation: params[:user][:password])
    end

    def user_params_for_name_update
      params.require(:user).permit(:name, :password, :password_confirmation)
                                  .merge(password_confirmation: params[:user][:password])
    end

    def user_params_for_email_update
      params.require(:user).permit(:email, :password, :password_confirmation)
                                  .merge(password_confirmation: params[:user][:password])
    end

    def user_params_for_password_update
      params.require(:user).permit(:password, :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end

    def admin_user
      redirect_to (root_url) unless current_user.admin?
    end

    def update_user(target, user, strong_params, password = :password)
      if user.authenticate(params[:user][password])
        if user.update_attributes(strong_params)
          flash[:success] = "Updated #{target}"
          redirect_to user
        else
          render "settings/change_#{target}"
        end
      else
        flash.now[:danger] = 'Wrong password'
        render "settings/change_#{target}"
      end
    end

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

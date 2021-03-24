class MessagesController < ApplicationController
  before_action :logged_in_user
  before_action :have_entry,   only: :create
  before_action :correct_user, only: :destroy

  def create
    @message = Message.create(message_params)
    redirect_to room_url(@message.room)

  end

  def destroy
      @message.destroy
      redirect_back(fallback_location: root_url)
  end

  private

    def message_params
      params.require(:message).permit(:user_id, :room_id, :content,
                                      :addressee_user_id, :read)
                              .merge(user_id: current_user.id, read: false)
    end

    def have_entry
      unless Entry.where(user_id: current_user.id,
                         room_id: params[:message][:room_id]).present?
        redirect_to root_url
      end
    end

    def correct_user
      @message = current_user.sent_messages.find_by(id: params[:id])
      redirect_to root_url if @message.nil?
    end
end

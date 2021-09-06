class MessagesController < ApplicationController
  before_action :authenticate_user!, :only => [:create]

  def create
    if Entry.where(user_id: current_user.id, room_id: params[:message][:room_id]).present?
      @message = Message.create(message_params)
      @room = Room.find(params[:message][:room_id])
      @messages = Message.includes(:user).where(room_id: @room.id)
      if @message.save
        # 通知を作成
        @message_room = @message.room
        @message_room.create_notification_message!(current_user, @message.id)
      else
        @messages = @room.messages.includes(:user)
        @message = Message.new
        @entries = @room.entries.includes(:user).where.not(user_id: current_user.id)
        render template: "rooms/show"
      end
    else
      redirect_back(fallback_location: users_path)
    end
  end

  def destroy
    message = Message.find(params[:id])
    message.destroy
    @room = Room.find(params[:room_id])
    @messages = Message.includes(:user).where(room_id: @room.id)
  end

  private

  def message_params
    params.require(:message).permit(:user_id, :content, :room_id).merge(user_id: current_user.id)
  end
end

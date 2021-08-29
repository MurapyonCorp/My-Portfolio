class MessagesController < ApplicationController
  before_action :authenticate_user!, :only => [:create]

  def create
    if Entry.where(:user_id => current_user.id, :room_id => params[:message][:room_id]).present?
      @message = Message.create(message_params)
      @messages = Message.includes(:user)
    else
      redirect_back(fallback_location: users_path)
    end
  end

  def destroy
    message = Message.find(params[:id])
    message.destroy
    @messages = Message.includes(:user)
  end

  private

  def message_params
    params.require(:message).permit(:user_id, :content, :room_id).merge(user_id: current_user.id)
  end
end

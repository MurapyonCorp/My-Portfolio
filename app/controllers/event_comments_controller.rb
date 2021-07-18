class EventCommentsController < ApplicationController
  def create
    event = Event.find(params[:event_id])
    comment = current_user.event_comments.new(event_comment_params)
    comment.event_id = event.id
    comment.save
    @event = comment.event
    @event_comments = EventComment.includes(:event, :user).where(event_id: params[:event_id])
    #通知の作成
    @event.create_notification_event_comment!(current_user, comment.id)
  end

  def destroy
    event_comment = EventComment.find_by(id: params[:id], event_id: params[:event_id])
    event_comment.destroy
    @event = event_comment.event
    @event_comments = EventComment.includes(:event, :user).where(event_id: params[:event_id])
  end

  private

  def event_comment_params
    params.require(:event_comment).permit(:comment)
  end
end

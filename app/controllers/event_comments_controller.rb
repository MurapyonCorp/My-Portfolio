class EventCommentsController < ApplicationController
  def create
    event = Event.find(params[:event_id])
    comment = current_user.event_comments.new(event_comment_params)
    comment.event_id = event.id
    comment.save
    @event = comment.event
    #通知の作成
    @comment_event.create_notification_event_comment!(current_user, @event_comment.id)
  end

  def destroy
    event_comment = EventComment.find_by(id: params[:id], event_id: params[:event_id])
    event_comment.destroy
    @event = event_comment.event
  end

  private

  def event_comment_params
    params.require(:event_comment).permit(:comment)
  end
end

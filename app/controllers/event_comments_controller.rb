class EventCommentsController < ApplicationController
  def create
    event = Event.find(params[:event_id])
    comment = current_user.event_comments.new(event_comment_params)
    comment.event_id = event.id
    comment.save
    @event = comment.event
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
class EventCommentsController < ApplicationController
  def create
    event = Event.find(params[:event_id])
    comment = current_user.event_comments.new(event_comment_params)
    comment.event_id = event.id
    comment.save
    redirect_to request.referer
  end

  def destroy
    EventComment.find_by(id: params[:id], event_id: params[:event_id]).destroy
    redirect_to request.referer
  end

  private
  def event_comment_params
    params.require(:event_comment).permit(:comment)
  end
end
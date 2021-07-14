class TaskCommentsController < ApplicationController
  def create
    task = Task.find(params[:task_id])
    comment = current_user.task_comments.new(task_comment_params)
    comment.task_id = task.id
    comment.save
    @task = comment.task
    #通知の作成
    @comment_task.create_notification_task_comment!(current_user, @task_comment.id)
  end

  def destroy
    task_comment = TaskComment.find_by(id: params[:id], task_id: params[:task_id])
    task_comment.destroy
    @task = task_comment.task
  end

  private

  def task_comment_params
    params.require(:task_comment).permit(:comment)
  end
end

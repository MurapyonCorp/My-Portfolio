class TaskCommentsController < ApplicationController
  def create
    @task = Task.find(params[:task_id])
    @comment = current_user.task_comments.new(task_comment_params)
    @comment.task_id = @task.id
    if @comment.save
      @task = @comment.task
      @task_comments = TaskComment.includes(:task, :user).where(task_id: params[:task_id])
      # 通知の作成
      @task.create_notification_task_comment!(current_user, @comment.id)
    else
      @user = @task.user
      @task_comments = TaskComment.includes(:user).where(task_id: @task.id)
      @task_comment = TaskComment.new
      render template: "tasks/show"
    end
  end

  def destroy
    task_comment = TaskComment.find_by(id: params[:id], task_id: params[:task_id])
    task_comment.destroy
    @task = task_comment.task
    @task_comments = TaskComment.includes(:task, :user).where(task_id: params[:task_id])
  end

  private

  def task_comment_params
    params.require(:task_comment).permit(:comment)
  end
end

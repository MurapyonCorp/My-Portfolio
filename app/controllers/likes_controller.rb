class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @task = Task.find(params[:task_id])
    like = current_user.likes.new(task_id: @task.id)
    like.save
    # 通知の作成
    @task.create_notification_by(current_user)
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js
    end
  end

  def destroy
    @task = Task.find(params[:task_id])
    like = current_user.likes.find_by(task_id: @task.id)
    @task.destroy_notification_by(current_user)
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js
    end
    like.destroy
  end
end

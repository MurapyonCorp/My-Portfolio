class LikesController < ApplicationController
  def create
    @task = Task.find(params[:task_id])
    like = current_user.likes.new(task_id: @task.id)
    like.save
  end

  def destroy
    @task = Task.find(params[:task_id])
    like = current_user.likes.find_by(task_id: @task.id)
    like.destroy
  end
end

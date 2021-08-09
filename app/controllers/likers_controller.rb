class LikersController < ApplicationController
  def index
    # イベントIDを取得する。
    @task = Task.find(params[:task_id])
    # そのイベントIDに結びついたfavoriteを持ってくるために引数にイベントIDの値を渡す。
    @likes = Like.includes(:user).where(task_id: @task.id).page(params[:page])
  end
end

class TasksController < ApplicationController
  def create
    @task = Task.new(task_params)
    # 投稿者IDとログインユーザーのIDを結びつける。
    @task.user_id = current_user.id
    if @task.save
      redirect_to request.referer
    else
      @tasks = Task.all
      render :index
    end
  end

  def index
    @tasks = Task.all
    @task = Task.new
    gon.g_key = "#{ENV['GCAL_API']}"
  end

  def show
    @task = Task.find(params[:id])
    @user = @task.user
    @task_comments = TaskComment.includes(:user).where(task_id: @task.id)
    if params[:checked].present?
      notification = @task.notifications.find_by!(visited_id: current_user.id)
      notification.update!(checked: true)
    end
    # 記入されたコメントを受ける空の箱を用意する。
    @task_comment = TaskComment.new
  end

  def edit
    @task = Task.find(params[:id])
    @user = @task.user
    # ログインしているユーザーがログインユーザー以外の編集ページにURLから直接遷移出来ないようにする。
    if @user != current_user
      redirect_to task_path(@task)
    end
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to tasks_path
    else
      @user = @task.user
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:title, :body, :start_date, :end_date)
  end
end

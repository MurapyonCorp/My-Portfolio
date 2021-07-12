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
  end

  def show
    @task = Task.find(params[:id])
    @user = @task.user
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
    params.require(:task).permit(:title, :body, :pratical, :start_date, :end_date)
  end
end

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
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def task_params
    params.require(:task).permit(:title, :body, :pratical, :start_date, :end_date)
  end
end

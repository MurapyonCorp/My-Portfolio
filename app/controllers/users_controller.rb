class UsersController < ApplicationController
  def index
    @users = User.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @events = @user.events.page(params[:page]).per(7)
    @tasks = @user.tasks.page(params[:page]).per(7)
    if params[:checked].present?
      # binding.pry
      notification = @user.notifications.find_by!(visited_id: current_user.id)
      notification.update!(checked: true)
    end
  end

  def edit
    @user = User.find(params[:id])
    # ログインしているユーザーがログインユーザー以外の編集ページにURLから直接遷移出来ないようにする。
    if @user != current_user
      redirect_to user_path(current_user)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(current_user)
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :profile_image, :introduction)
  end
end

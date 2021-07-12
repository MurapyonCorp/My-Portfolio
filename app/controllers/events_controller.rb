class EventsController < ApplicationController
  def create
    @event = Event.new(event_params)
    # 投稿者IDとログインユーザーのIDを結びつける。
    @event.user_id = current_user.id
    if @event.save
      redirect_to request.referer
    else
      @events = Event.all
      render :index
    end
  end

  def index
    @events = Event.all
    @event = Event.new
  end

  def show
    @event = Event.find(params[:id])
    @user = @event.user
    # コメント投稿するための空のメソッドを呼び出す
    @event_comment = EventComment.new
  end

  def edit
    @event = Event.find(params[:id])
    @user = @event.user
    # ログインしているユーザーがログインユーザー以外の編集ページにURLから直接遷移出来ないようにする。
    if @user != current_user
      redirect_to event_path(@event)
    end
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to events_path
    else
      @user = @event.user
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path
  end

  private
  def event_params
    params.require(:event).permit(:title, :body, :location, :start_date, :end_date)
  end
end

class FavoritersController < ApplicationController
  def index
    # イベントIDを取得する。
    @event = Event.find(params[:event_id])
    # そのイベントIDに結びついたfavoriteを持ってくるために引数にイベントIDの値を渡す。
    @favorites = Favorite.includes(:user).where(event_id: @event.id).page(params[:page])
  end
end

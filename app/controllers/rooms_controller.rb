class RoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    @room = Room.create
    @entry1 = Entry.create(:room_id => @room.id, :user_id => current_user.id)
    @entry2 = Entry.create(join_room_params)
    redirect_to room_path(@room.id)
  end

  def index
    # ログインユーザーに紐付いたエントリーを取得する。
    @currentEntries = current_user.entries.includes(:room)
    # ログインユーザーが属しているRoomのidを格納するための空配列を生成。
    myRoomIds = []
    # each文を使ってログインユーザーのRoomのidを配列に格納する。
    @currentEntries.each do |entry|
      myRoomIds << entry.room.id
    end
    # Entryテーブルのログインユーザーが入っているroomのidとログインユーザーではない他ユーザーのuser_idをanotherEntriesに格納する。
    @anotherEntries = Entry.includes(:room, :user).where(room_id: myRoomIds).where('user_id != ?',@user.id).page(params[:page])
  end

  def show
    @room = Room.find(params[:id])
    if Entry.where(:user_id => current_user.id, :room_id => @room.id).present?
      @messages = @room.messages.includes(:user)
      @message = Message.new
      @entries = @room.entries.includes(:user).where.not(user_id: current_user.id)
    else
      redirect_back(fallback_location: users_path)
    end
  end

  private

  def join_room_params
    params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id)
  end
end

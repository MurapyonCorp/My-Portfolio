class Room < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :notifications, dependent: :destroy

  def create_notification_message!(current_user, message_id)
    # Entryテーブルの中のログインユーザー以外のユーザーIDを取得する
    # array_user_id = Entry.where(room_id: id).where.not(user_id: current_user.id).pluck(:user_id)
    # user_id = array_user_id[0]
    another_user = Entry.where(room_id: id).where.not(user_id: current_user.id)
    user_id = (another_user.to_a)[0].user_id
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = Message.select(:user_id).where(room_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_message!(current_user, message_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_message!(current_user, message_id, user_id) if temp_ids.blank?
  end

  def save_notification_message!(current_user, message_id, visited_id)
    notification = current_user.active_notifications.new(
      room_id: id,
      message_id: message_id,
      visited_id: visited_id,
      action: 'DM'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visiter_id == notification.visited_id
        notification.checked = true
    end
    notification.save if notification.valid?
  end
end

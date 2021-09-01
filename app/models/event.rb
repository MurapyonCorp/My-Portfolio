class Event < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy

  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true
  validates :location, presence: true, format: {with: /\A[a-zA-Zぁ-んァ-ン一-龥0-9０-９]/}
  validates :location, presence: true, format: {without: /\A[0-9０-９]+\z/}
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :start_end_check
  validate :start_check

  def start_end_check         #開始時間と終了時間を比較する。
    if (start_date != nil) && (end_date != nil)
      errors.add(:end_date, "は開始時刻より遅い時間を選択してください") if self.start_date > self.end_date
    end
  end

  def start_check             #開始時間と現在の時刻を比較する。
    if start_date != nil
      errors.add(:start_date, "は現在の日時より遅い時間を選択してください") if self.start_date < Time.now
    end
  end


  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  has_many :event_comments, dependent: :destroy

  # 検索方法を分岐させる
  def self.looks(search, word)
    @event = Event.where("title LIKE?", "%#{word}%")
  end

  # 通知モデルとのアソシエーション関係
  has_many :notifications, dependent: :destroy
  def create_notification_by(current_user)
    temp = Notification.where(["visiter_id = ? and visited_id = ? and event_id = ? and action = ? ", current_user.id, user_id, id, 'favorite'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        event_id: id,
        visited_id: user_id,
        action: "favorite"
      )
      notification.save if notification.valid?
    end
  end

  # いいねを外した時の通知
  def destroy_notification_by(current_user)
    notification = current_user.active_notifications.find_by(
      event_id: id,
      visited_id: user_id,
      action: "favorite"
    )
    notification.destroy
  end

  def create_notification_event_comment!(current_user, event_comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = EventComment.select(:user_id).where(event_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_event_comment!(current_user, event_comment_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_event_comment!(current_user, event_comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_event_comment!(current_user, event_comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      event_id: id,
      event_comment_id: event_comment_id,
      visited_id: visited_id,
      action: 'event_comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visiter_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
end

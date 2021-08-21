class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 画像をrefileで使えるようにする
  attachment :profile_image

  validates :name, presence: true, uniqueness: true, length: { maximum: 10 }
  validates :introduction, length: { maximum: 50 }

  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower
  # 被フォロー関係を通じて参照→followed_idをフォローしている人

  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # 【class_name: "Relationship"】は省略可能
  has_many :followings, through: :relationships, source: :followed
  # 与フォロー関係を通じて参照→follower_idをフォローしている人
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  # イベントモデルとのアソシエーションの関係
  has_many :events
  # タスクモデルとのアソシエーションの関係
  has_many :tasks
  # いいねモデルとのアソシエーションの関係
  has_many :favorites, dependent: :destroy
  def own?(object)
    id == object.user_id
  end
  # タスクのいいねモデルとアソシエーションの関係
  has_many :likes, dependent: :destroy
  def own?(object)
    id == object.user_id
  end

  # イベントコメントモデルとのアソシエーションの関係
  has_many :event_comments, dependent: :destroy
  # タスクコメントモデルとのアソシエーションの関係
  has_many :task_comments, dependent: :destroy

  # 検索方法分岐を分岐させる
  def self.looks(search, word)
    @user = User.where("name LIKE?", "%#{word}%")
  end

  # 通知モデルのとアソシエーション関係(自分が送った通知と自分宛の通知で分ける。)
  has_many :active_notifications, class_name: "Notification", foreign_key: "visiter_id", dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: "visited_id", dependent: :destroy
  # フォロー時の通知
  def create_notification_follow!(current_user, visited_id)
    temp = Notification.where(["visiter_id = ? and visited_id = ? and action = ? ", current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: visited_id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
end

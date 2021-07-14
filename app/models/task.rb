class Task < ApplicationRecord
  belongs_to :user
  enum pratical: { 実施済: true, 未実施: false }
  has_many :likes, dependent: :destroy

  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  # タスクコメントモデルとのアソシエーションの関係
  has_many :task_comments, dependent: :destroy

  # 検索方法を分岐させる
  def self.looks(search, word)
    if search == "perfect_match"
      @task = Task.where("title LIKE?","#{word}")
    elsif search == "partial_match"
      @task = Task.where("title LIKE?","%#{word}%")
    else
      @task = Task.all
    end
  end
end

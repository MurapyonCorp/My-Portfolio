class Task < ApplicationRecord
  belongs_to :user
  enum pratical: {実施済: true, 未実施: false}
  has_many :likes, dependent: :destroy

  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end
end

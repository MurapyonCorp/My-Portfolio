class Event < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  has_many :event_comments, dependent: :destroy
  
  # 検索方法を分岐させる
  def self.looks(search, word)
    if search == "perfect_match"
      @event = Event.where("title LIKE?","#{word}")
    elsif search == "partial_match"
      @event = Event.where("title LIKE?","%#{word}%")
    else
      @event = Event.all
    end
  end
end

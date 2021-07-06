class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 画像をrefileで使えるようにする
  attachment :profile_image
  # イベントモデルとのアソシエーションの関係
  has_many :events
end

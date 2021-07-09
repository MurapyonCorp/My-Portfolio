class Relationship < ApplicationRecord
  # class_name: "User"でUserテーブルのレコードを参照する。
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
end

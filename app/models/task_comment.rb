class TaskComment < ApplicationRecord
  belongs_to :user
  belongs_to :task

  has_many :notifications, dependent: :destroy

  validates :comment, presence: true
end

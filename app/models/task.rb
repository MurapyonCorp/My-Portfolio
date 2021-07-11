class Task < ApplicationRecord
  belongs_to :user
  enum pratical: {実施済: true, 未実施: false}
end

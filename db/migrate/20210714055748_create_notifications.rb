class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :visiter_id
      t.integer :visited_id
      t.integer :event_id
      t.integer :task_id
      t.integer :event_comment_id
      t.integer :task_comment_id
      t.integer :room_id
      t.integer :message_id
      t.string :action
      t.boolean :checked, default: false, null: false

      t.timestamps
    end
  end
end

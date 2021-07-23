# frozen_string_literal: true

require 'rails_helper'

Rspec.describe 'Notificationモデルのテスト', type: :model do
  describe 'アソシエーションのテスト' do
    context "Userモデルとの関係" do
      it "1:Nの関係になっている" do
        expect(Notification.reflect_on_association(:visiter).macro).to eq :belongs_to
      end
    end
    context "Userモデルとの関係" do
      it "1:Nの関係になっている" do
        expect(Notification.reflect_on_association(:visited).macro).to eq :belongs_to
      end
    end
    context 'Eventモデルとの関係' do
      it '1:Nの関係になっている' do
        expect(Notification.reflect_on_association(:event).macro).to eq :belongs_to
      end
    end
    context 'Taskモデルとの関係' do
      it '1:Nの関係になっている' do
        expect(Notification.reflect_on_association(:task).macro).to eq :belongs_to
      end
    end
    context "EventCommentモデルとの関係" do
      it "1:Nの関係になっている" do
        expect(Notification.reflect_on_association(:event_comment).macro).to eq :belongs_to
      end
    end
    context "TaskCommentモデルとの関係" do
      it "1:Nの関係になっている" do
        expect(Notification.reflect_on_association(:task_comment).macro).to eq :belongs_to
      end
    end
  end
end
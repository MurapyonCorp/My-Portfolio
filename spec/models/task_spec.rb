# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Taskモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { task.valid? }

    let!(:user) { create(:user) }
    let!(:task) { build(:task, user_id: user.id) }

    context 'titleカラム' do
      it '空欄でないこと' do
        task.title = ''
        is_expected.to eq false
      end
      it '100文字以下であること: 100文字はOK' do
        task.title = Faker::Lorem.characters(number: 100)
        is_expected.to eq true
      end
      it '100文字以下であること: 101文字はNG' do
        task.title = Faker::Lorem.characters(number: 101)
        is_expected.to eq false
      end
    end
    context 'bodyカラム' do
      it '空欄でないこと' do
        task.body = ''
        is_expected.to eq false
      end
    end
    context 'start_dateカラム' do
      it '空欄でないこと' do
        task.start_date = ''
        is_expected.to eq false
      end
    end
    context 'end_dateカラム' do
      it '空欄でないこと' do
        task.end_date = ''
        is_expected.to eq false
      end
    end
  end
  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it '1:Nの関係になっている' do
        expect(Task.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'TaskCommentモデルとの関係' do
      it '1:Nの関係になっている' do
        expect(Task.reflect_on_association(:task_comments).macro).to eq :has_many
      end
    end
    context 'Notificationモデルとの関係' do
      it '1:Nの関係になっている' do
        expect(Task.reflect_on_association(:notifications).macro).to eq :has_many
      end
    end
    context 'Likeモデルとの関係' do
      it '1:Nの関係になっている' do
        expect(Task.reflect_on_association(:likes).macro).to eq :has_many
      end
    end
  end
end
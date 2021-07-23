# frozen_string_literal: true

require 'rails_helper'

Rspec.describe 'EventCommentモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { event_comment.valid? }

    let(:user) { create(:user) }
    let!(:event) { build(:event, user_id: user.id) }

    context 'titleカラム' do
      it '空欄でないこと' do
        event.title = ''
        is_expected.to eq false
      end
      it '100文字以下であること: 100文字はOK' do
        event.title = Faker::Lorem.characters(number: 100)
        is_expected.to eq true
      end
      it '100文字以下であること: 101文字はNG' do
        event.title = Faker::Lorem.characters(number: 101)
        is_expected.to eq false
      end
    end
    context 'bodyカラム' do
      it '空欄でないこと' do
        event.body = ''
        is_expected.to eq false
      end
    end
    context 'locationカラム' do
      it '空欄でないこと' do
        event.location = ''
        is_expected.to eq false
      end
    end
    context 'start_dateカラム' do
      it '空欄でないこと' do
        event.start_date = ''
        is_expected.to eq false
      end
    end
    context 'end_dateカラム' do
      it '空欄でないこと' do
        event.end_date = ''
        is_expected.to eq false
      end
    end
  end
  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it '1:Nの関係になっている' do
        expect(Event.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'EventCommentモデルとの関係' do
      it '1:Nの関係になっている' do
        expect(Event.reflect_on_association(:event_comment).macro).to eq :has_many
      end
    end
    context 'Notificationモデルとの関係' do
      it '1:Nの関係になっている' do
        expect(Event.reflect_on_association(:notification).macro).to eq :has_many
      end
    end
    context 'Favoriteモデルとの関係' do
      it '1:Nの関係になっている' do
        expect(Event.reflect_on_association(:favorite).macro).to eq :has_many
      end
    end
  end
end
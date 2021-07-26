# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'EventCommentモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { event_comment.valid? }

    let(:user) { create(:user) }
    let!(:event) { build(:event, user_id: user.id) }
    let!(:event_comment) { build(:event_comment, user_id: user.id) }

    context 'commentカラム' do
      it '空欄でないこと' do
        event_comment.comment = ''
        is_expected.to eq false
      end
    end
  end
  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it '1:Nの関係になっている' do
        expect(EventComment.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Eventモデルとの関係' do
      it '1:Nの関係になっている' do
        expect(EventComment.reflect_on_association(:event).macro).to eq :belongs_to
      end
    end
    context 'Notificationモデルとの関係' do
      it '1:Nの関係になっている' do
        expect(EventComment.reflect_on_association(:notification).macro).to eq :has_many
      end
    end
  end
end
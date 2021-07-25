# frozen_string_literal: true

require 'rails_helper'

Rspec.describe 'Likeモデルのテスト', type: :model do
  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it '1:Nの関係になっている' do
        expect(Like.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Taskモデルとの関係' do
      it '1:Nの関係になっている' do
        expect(Like.reflect_on_association(:task).macro).to eq :belongs_to
      end
    end
  end
end
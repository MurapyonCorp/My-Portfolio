# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Likeモデルのテスト', type: :model do
  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1の関係になっている' do
        expect(Like.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Taskモデルとの関係' do
      it 'N:1の関係になっている' do
        expect(Like.reflect_on_association(:task).macro).to eq :belongs_to
      end
    end
  end
end
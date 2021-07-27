# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Relationshipモデルのテスト', type: :model do
  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1の関係になっている' do
        expect(Relationship.reflect_on_association(:follower).macro).to eq :belongs_to
      end
    end
    context 'Userモデルとの関係' do
      it 'N:1の関係になっている' do
        expect(Relationship.reflect_on_association(:followed).macro).to eq :belongs_to
      end
    end
  end
end
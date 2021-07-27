# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { user.valid? }

    let!(:other_user) { create(:user) }
    let!(:user) { create(:user) }
    let!(:task) { create(:task) }

    context 'nameカラム' do
      it '空欄でないこと' do
        user.name = ''
        is_expected.to eq false
      end
      it '10文字以下であること: 10文字はOK' do
        user.name = 'abcdefghij'
        is_expected.to eq true
      end
      it '10文字以下であること: 11文字はNG' do
        user.name = 'abcdefghijk'
        is_expected.to eq false
      end
      it '一意性があること' do
        user.name = other_user.name
        is_expected.to eq false
      end
    end
    context 'introductionカラム' do
      it '50文字以下であること: 50文字はOK' do
        user.introduction = Faker::Lorem.characters(number: 50)
        is_expected.to eq true
      end
      it '50文字以下であること: 51文字はNG' do
        user.introduction = Faker::Lorem.characters(number: 51)
        is_expected.to eq false
      end
    end
  end
  describe 'アソシエーションのテスト' do
    context 'Eventモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:events).macro).to eq :has_many
      end
    end
    context 'Taskモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:tasks).macro).to eq :has_many
      end
    end
    context 'Relationshipモデルとの関係: follower_id' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:relationships).macro).to eq :has_many
      end
    end
    context 'Relationshipモデルとの関係: followed_id' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:reverse_of_relationships).macro).to eq :has_many
      end
    end
    context 'EventCommentモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:event_comments).macro).to eq :has_many
      end
    end
    context 'TaskCommentモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:task_comments).macro).to eq :has_many
      end
    end
    context 'Favoriteモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end
    context 'Likeモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:likes).macro).to eq :has_many
      end
    end
  end
end
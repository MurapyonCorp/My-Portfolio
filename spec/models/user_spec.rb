# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { user.valid? }

    let!(:other_user) { create(:user) }
    let(:user) { build(:user) }

    context 'nameカラム' do
      it '空欄でないこと' do
        user.name = ''
        is_expected.to eq false
      end
      it '10文字以下であること: 10文字はOK' do
        user.name = Faker::Name.last_name(number: 10)
        is_expected.to eq true
      end
      it '10文字以下であること: 11文字はNG' do
        user.name = Faker::Name.last_name(number: 11)
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
      it '50文字以下であること: 510文字はNG' do
        user.introduction = Faker::Lorem.characters(number: 51)
        is_expected.to eq false
      end
    end
  end
  describe 'アソシエーションのテスト' do
    context ''
  end
end
FactoryBot.define do
  factory :event_comment do
    comment { Faker::Lorem.characters}
  end
end
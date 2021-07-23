FactoryBot.define do
  factory :task do
    title { Faker::Lorem.characters(number: 10) }
    body { Faker::Lorem.characters(number: 50) }
    pratical { Faker::Boolean.boolean(true_ratio: 0.2) }
    start_date { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    end_date { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    user
  end
end
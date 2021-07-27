FactoryBot.define do
  factory :task_comment do
    comment { Faker::Lorem.characters}
    user
    task
  end
end
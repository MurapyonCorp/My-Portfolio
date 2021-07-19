# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(
  [
    {
      name: 'Murapyon',
      email: 'a@a.com',
      password: '111111',
      profile_image_id: 'e2bc01079a674c1f4ae6125e7a9b3aca627a1e9b685dc3de2872854e0d48',
      introduction: 'よろしくおねしゃす'
    },
    {
      name: 'ryo',
      email: 'a@c.com',
      password: '222222',
      profile_image_id: 'cf95bfa6c2d99465c92ee791fae77ff7efb54f4d2619f5e1e89e869841c9',
      introduction: '今日も1日頑張るぞ～'
    }
  ]

)

10.times do |n|
  User.create!(
    [
      {
        name: "a",
        email: "a@#{n + 1}.com",
        password: "333333",
        introduction: "Hello"
      }
    ]
  )
end

Event.create!(
  [
    {
      user_id: 1,
      title: 'full calendar',
      body: '大きくてとても見やすいカレンダー',
      location: '東京ドーム',
      start_date: '2021-07-12 14:27:00',
      end_date: '2021-07-12 15:27:00'
    },
    {
      user_id: 2,
      title: 'work tour',
      body: 'すごく楽しみ！',
      location: '通天閣',
      start_date: '2021-07-21 15:00:00',
      end_date: '2021-07-22 18:00:00'
    }
  ]
)

Task.create!(
  [
    {
      user_id: 2,
      title: 'running',
      body: '今日も朝に公園で走ります',
      pratical: '未実施',
      start_date: '2021-07-12 9:27:00',
      end_date: '2021-07-12 10:27:00'
    },
    {
      user_id: 1,
      title: 'ジムに行く',
      body: '今日もしっかりと鍛え上げるぞ～',
      pratical: '未実施',
      start_date: '2021-07-23 13:00:00',
      end_date: '2021-07-23 16:00:00'
    }
  ]
)

10.times do |n|
  Event.create!(
    [
      {
        user_id: 1,
        title: "Live#{n + 1}",
        body: 'Winter Live',
        location: '幕張メッセ',
        start_date: "2021-07-#{14 + n} 14:27:00",
        end_date: "2021-07-#{15 + n} 15:27:00"
      },
      {
        user_id: 2,
        title: "Summer Festival#{n + 1}",
        body: 'Summer Live',
        location: '東京ドーム',
        start_date: "2021-07-#{17 + n} 14:27:00",
        end_date: "2021-07-#{18 + n} 15:27:00"
      }
    ]
  )
end

10.times do |n|
  Task.create!(
    [
      {
        user_id: 1,
        title: "Walking#{n + 1}",
        body: 'health',
        pratical: '未実施',
        start_date: "2021-07-#{14 + n} 14:27:00",
        end_date: "2021-07-#{15 + n} 15:27:00"
      },
      {
        user_id: 2,
        title: "dancing#{n + 1}",
        body: "Let's dance!",
        pratical: '未実施',
        start_date: "2021-07-#{17 + n} 14:27:00",
        end_date: "2021-07-#{18 + n} 15:27:00"
      }
    ]
  )
end
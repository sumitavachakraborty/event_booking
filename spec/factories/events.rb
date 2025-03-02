FactoryBot.define do
  factory :event do
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph }
    venue { Faker::Address.city }
    event_date { Faker::Time.between(from: DateTime.now + 1, to: DateTime.now + 90) }
    association :event_organizer
  end
end
FactoryBot.define do
  factory :booking do
    quantity { Faker::Number.between(from: 1, to: 5) }
    total_price { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    association :customer
    association :event
    association :ticket
  end
end
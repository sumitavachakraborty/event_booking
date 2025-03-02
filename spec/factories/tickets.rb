FactoryBot.define do
  factory :ticket do
    name { ["General Admission", "VIP", "Early Bird"].sample }
    price { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    quantity_available { Faker::Number.between(from: 10, to: 500) }
    association :event
  end
end
FactoryGirl.define do
  factory :opening_time do
    day { Faker::Number.between(0, 6) }
    opens_at { Time.now }
    closes_at { Time.now + 1.minute }
    valid_from { Date.today }
    valid_through { nil }
    branch_id { FactoryGirl.create(:branch).id}
  end
end

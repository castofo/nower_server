FactoryGirl.define do
  factory :contact_information do
    key { Faker::Lorem.characters(Faker::Number.between(10, 20)) }
    value { Faker::Lorem.word }
    store_id { FactoryGirl.create(:store).id }
  end
end

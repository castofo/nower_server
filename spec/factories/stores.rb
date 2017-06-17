FactoryGirl.define do
  factory :store do
    name { Faker::Company.name }
    description { Faker::Lorem.paragraph }
    nit { Faker::Lorem.characters(15) }
    website { Faker::Internet.url }
    address { Faker::Address.street_address }
    status { :pending_documentation }
  end
end

FactoryGirl.define do
  factory :branch do
    latitude Faker::Address.latitude
    longitude Faker::Address.longitude
    address Faker::Address.street_address
    default_contact_info false
  end
end

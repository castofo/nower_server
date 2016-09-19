require 'faker'

FactoryGirl.define do
  name = Faker::Name.name

  factory :user do
    first_name name.split(' ').first
    last_name name.split(' ').second
    email Faker::Internet.email name
    password Faker::Internet.password
    birthday Faker::Date.between(70.years.ago, 5.years.ago)
    gender [nil, 'M', 'F'].sample
  end
end

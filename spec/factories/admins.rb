FactoryGirl.define do
  name = Faker::Name.name

  factory :admin do
    first_name name.split(' ').first
    last_name name.split(' ').second
    email Faker::Internet.email name
    password Faker::Internet.password(8)
    admin_type [:branch_admin].sample
    privileges []
    activated_at nil

    factory :admin_activated do
      activated_at Faker::Date.between(60.days.ago, 1.hour.ago)
    end
  end
end

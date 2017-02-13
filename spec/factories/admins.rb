FactoryGirl.define do
  factory :admin do
    email Faker::Internet.email
    password Faker::Internet.password(8)
    admin_type [:branch_admin].sample
    privileges []
    activated_at nil

    factory :admin_activated do
      activated_at Faker::Date.between(60.days.ago, 1.hour.ago)
    end
  end
end

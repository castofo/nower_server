require 'faker'

FactoryGirl.define do
  factory :promo do
    name Faker::Lorem.sentence
    description Faker::Lorem.paragraph
    terms Faker::Lorem.paragraph
    stock Faker::Number.between(1, 1000)
    price Faker::Number.decimal(5, 2)
    start_date nil
    end_date nil

    factory :promo_with_dates do
      start_date Faker::Date.between(1.days.from_now, 3.days.from_now)
      end_date Faker::Date.between(5.days.from_now, 10.days.from_now)
    end

    factory :promo_already_started do
      start_date Faker::Date.between(10.days.ago, 3.days.ago)
      end_date Faker::Date.between(5.days.from_now, 10.days.from_now)
      to_create { |instance| instance.save(validate: false) }
    end
  end
end

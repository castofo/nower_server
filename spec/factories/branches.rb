FactoryGirl.define do
  factory :branch do
    name { Faker::Address.street_name }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    address { Faker::Address.street_address }
    default_contact_info { false }
    store_id { FactoryGirl.create(:store).id }

    factory :branch_with_promos do
      promos do
        result = []
        rand(1..10).times { result.push(create :promo) }
        result
      end
    end
  end
end

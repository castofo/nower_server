require 'rails_helper'

RSpec.describe 'Promos', type: :request do
  describe 'GET /v1/promos' do
    context 'when there is no promos' do
      it 'returns an empty array' do
        sub_get api_v1_promos_path
        expect(response).to have_http_status(200)
        promos = JSON.parse(response.body)
        expect(promos).to be_a_kind_of Array
        expect(promos).to be_empty
      end
    end

    context 'when there is a promo' do
      let!(:existing_promo) { create :promo }
      it 'returns an array with the promo' do
        sub_get api_v1_promos_path
        expect(response).to have_http_status(200)
        promos = JSON.parse(response.body)
        expect(promos.length).to eq 1
        expect(promos.first['id']).to eq existing_promo.id
        expect(promos.first['name']).to eq existing_promo.name
        expect(promos.first['description']).to eq existing_promo.description
      end
    end

    context "when 'branch_id' query param is included" do
      let(:existing_branch) { create :branch }
      let(:associated_count) { rand(5..10) }

      # Create promos associated to existing branch
      before do
        associated_count.times do
          promo = build(:promo)
          promo.branches.push(existing_branch)
          promo.save
        end
      end

      # Create some other branches that are not associated to existing branch
      before do
        rand(5..10).times { create(:promo) }
      end

      it 'returns only promos that belong to the given branch' do
        sub_get api_v1_promos_path, { params: { branch_id: existing_branch.id } }
        expect(response).to have_http_status(200)
        promos = JSON.parse(response.body)
        expect(promos.length).to eq associated_count
      end
    end

    context "when 'expired' query param is 'true'" do
      # Create some expired and non-expired promos
      expired_promos = rand(5..10)
      non_expired_promos = rand(5..10)
      before do
        expired_promos.times { create :promo_expired }
        non_expired_promos.times { create :promo }
      end

      it 'returns promos regardless of they are expired or not' do
        sub_get api_v1_promos_path, { params: { expired: :true } }
        expect(response).to have_http_status(200)
        promos = JSON.parse(response.body)
        expect(promos.count).to eq expired_promos + non_expired_promos
      end
    end

    context "when 'expired' query param is 'false'" do
      # Create some expired and non-expired promos
      expired_promos = rand(5..10)
      non_expired_promos = rand(5..10)
      before do
        expired_promos.times { create :promo_expired }
        non_expired_promos.times { create :promo }
      end

      it 'returns only promos that are not expired' do
        sub_get api_v1_promos_path, { params: { expired: :false } }
        expect(response).to have_http_status(200)
        promos = JSON.parse(response.body)
        expect(promos.count).to eq non_expired_promos
      end
    end

    context "when 'expired' query param is not specified" do
      # Create some expired and non-expired promos
      expired_promos = rand(5..10)
      non_expired_promos = rand(5..10)
      before do
        expired_promos.times { create :promo_expired }
        non_expired_promos.times { create :promo }
      end

      it 'returns only promos that are not expired' do
        sub_get api_v1_promos_path
        expect(response).to have_http_status(200)
        promos = JSON.parse(response.body)
        expect(promos.count).to eq non_expired_promos
      end
    end

    context "when 'expand' query param contains 'branches'" do
      # Create some promos and associate them to branches
      before do
        rand(5..10).times do
          promo = create :promo
          rand(5..10).times { promo.branches.push(create :branch) }
        end
      end

      it 'returns promos with embedded branches entities' do
        sub_get api_v1_promos_path, { params: { expand: :branches } }
        expect(response).to have_http_status(200)
        promos = JSON.parse(response.body)
        promos.each do |promo|
          expect(promo['branches']).not_to be_nil
          expect(promo['branches']).to be_a_kind_of(Array)
        end
      end
    end
  end

  describe 'GET /v1/promos/:id' do
    let(:existing_promo) { create :promo }
    context 'when id is valid' do
      it 'returns the promo' do
        sub_get api_v1_promo_path(existing_promo.id)
        expect(response).to have_http_status(200)
        found_promo = JSON.parse(response.body)
        expect(found_promo['id']).to eq existing_promo.id
        expect(found_promo['name']).to eq existing_promo.name
        expect(found_promo['description']).to eq existing_promo.description
      end
    end

    context "when 'expand' query param contains 'branches'" do
      let(:branches_count) { rand(5..10) }
      before do
        branches_count.times do
          existing_promo.branches.push(create :branch)
        end
      end
      it 'returns the promo with embedded branches entities' do
        sub_get api_v1_promo_path(existing_promo.id), { params: { expand: :branches } }
        expect(response).to have_http_status(200)
        found_promo = JSON.parse(response.body)
        expect(found_promo['branches']).not_to be_nil
        expect(found_promo['branches']).to be_a_kind_of(Array)
        expect(found_promo['branches'].length).to eq branches_count
      end
    end

    context 'when id is invalid' do
      it 'raises a RecordNotFound' do # No way to get the 404.
        expect do
          sub_get api_v1_promo_path('non-existing-id')
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'POST /v1/promos' do
    let(:body) { attributes_for :promo }
    context 'when all attributes are valid' do
      it 'creates the promo' do
        sub_post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(201)
        created_promo = JSON.parse(response.body)
        expect(created_promo['name']).to eq body[:name]
        expect(created_promo['description']).to eq body[:description]
        expect(created_promo['terms']).to eq body[:terms]
      end
    end

    context 'when name is not present' do
      it 'returns a 422' do
        body[:name] = nil
        sub_post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when name is empty' do
      it 'returns a 422' do
        body[:name] = ''
        sub_post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when name has more than 140 characters' do
      it 'returns a 422' do
        body[:name] = Faker::Lorem.characters(141)
        sub_post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when description is not present' do
      it 'returns a 422' do
        body[:description] = nil
        sub_post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when description is empty' do
      it 'returns a 422' do
        body[:description] = ''
        sub_post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when terms is not present' do
      it 'returns a 422' do
        body[:terms] = nil
        sub_post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when terms is empty' do
      it 'returns a 422' do
        body[:terms] = ''
        sub_post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when both stock and end_date are nil' do
      it 'returns a 422' do
        body[:stock] = nil
        body[:end_date] = nil
        sub_post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when stock is nil but end_date is not nil' do
      it 'returns a 201' do
        body[:stock] = nil
        body[:start_date] = Faker::Number.between(2, 15).days.from_now
        body[:end_date] = Faker::Number.between(17, 30).days.from_now
        sub_post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(201)
      end
    end

    context 'when stock is zero' do
      it 'returns a 422' do
        body[:stock] = 0
        sub_post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when price is negative' do
      it 'returns a 422' do
        body[:price] = Faker::Number.negative
        sub_post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when start_date is before current date' do
      it 'returns a 422' do
        body[:start_date] = Faker::Number.between(2, 15).days.ago
        sub_post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when start_date is equal to current date' do
      it 'returns a 201' do
        body[:start_date] = DateTime.now + 5.minutes
        sub_post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(201)
      end
    end

    context 'when start_date is after current date' do
      it 'returns a 201' do
        body[:start_date] = Faker::Number.between(2, 15).days.from_now
        sub_post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(201)
      end
    end

    context 'when end_date is nil but stock is not' do
      it 'returns a 201' do
        body[:stock] = Faker::Number.positive.to_i
        body[:end_date] = nil
        sub_post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(201)
      end
    end

    context 'when end_date is not nil but start_date is' do
      it 'returns a 422' do
        body[:end_date] = Faker::Number.between(2, 15).days.from_now
        body[:start_date] = nil
        sub_post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when end_date is before current date' do
      it 'returns a 422' do
        body[:end_date] = Faker::Number.between(2, 15).days.ago
        sub_post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when end_date is equal to current date' do
      it 'returns a 201' do
        body[:start_date] = DateTime.now + 2.minutes
        body[:end_date] = DateTime.now + 5.minutes
        sub_post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(201)
      end
    end

    context 'when end_date is after current date' do
      it 'returns a 201' do
        body[:start_date] = DateTime.now + 2.minutes
        body[:end_date] = Faker::Number.between(2, 15).days.from_now
        sub_post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(201)
      end
    end

    context 'when start_date is before end_date' do
      it 'returns a 201' do
        body[:start_date] = Faker::Number.between(2, 15).days.from_now
        body[:end_date] = Faker::Number.between(17, 30).days.from_now
        sub_post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(201)
      end
    end

    context 'when start_date is equal to before end_date' do
      it 'returns a 201' do
        body[:start_date] = Faker::Number.between(2, 15).days.from_now
        body[:end_date] = body[:start_date]
        sub_post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(201)
      end
    end

    context 'when start_date is after end_date' do
      it 'returns a 422' do
        body[:start_date] = Faker::Number.between(17, 30).days.from_now
        body[:end_date] = Faker::Number.between(2, 15).days.from_now
        sub_post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when branch_ids is nil' do
      it 'creates the promo without associated branches' do
        body[:branch_ids] = nil
        sub_post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(201)
        created_promo = JSON.parse(response.body)
        sub_get api_v1_promo_path(created_promo['id']), { params: { expand: :branches } }
        found_promo = JSON.parse(response.body)
        expect(found_promo['branches'].length).to eq 0
      end
    end

    context 'when branch_ids is empty array' do
      it 'creates the promo without associated branches' do
        body[:branch_ids] = []
        sub_post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(201)
        created_promo = JSON.parse(response.body)
        sub_get api_v1_promo_path(created_promo['id']), { params: { expand: :branches } }
        found_promo = JSON.parse(response.body)
        expect(found_promo['branches'].length).to eq 0
      end
    end

    context 'when branch_ids is present with some ids' do
      let(:branch_ids) do
        ids = []
        store = create :store
        rand(5..10).times do
          branch = create(:branch, store_id: store.id)
          ids.push(branch.id)
        end
        ids
      end

      it 'creates the promo with specified branches associated' do
        body[:branch_ids] = branch_ids
        sub_post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(201)
        created_promo = JSON.parse(response.body)
        sub_get api_v1_promo_path(created_promo['id']), { params: { expand: :branches } }
        found_promo = JSON.parse(response.body)
        expect(found_promo['branches'].length).to eq branch_ids.length
        found_promo['branches'].each { |branch| expect(branch_ids).to include(branch['id']) }
      end
    end
  end

  describe 'PUT /v1/promos' do
    let(:existing_promo) { create :promo }
    let(:body) do
      { name: Faker::Lorem.sentence[0..139], description: Faker::Lorem.paragraph }
    end
    context 'when updating an existing promo' do
      context 'when new name is valid' do
        it 'updates the promo' do
          sub_put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
          expect(response).to have_http_status(200)
          updated_promo = JSON.parse(response.body)
          expect(updated_promo['name']).to eq body[:name]
          expect(updated_promo['description']).to eq body[:description]
        end
      end

      context 'when name is nil' do
        it 'returns a 422' do
          body[:name] = nil
          sub_put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
          expect(response).to have_http_status(422)
        end
      end

      context 'when name is empty' do
        it 'returns a 422' do
          body[:name] = ''
          sub_put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
          expect(response).to have_http_status(422)
        end
      end

      context 'when name has more than 140 characters' do
        it 'returns a 422' do
          body[:name] = Faker::Lorem.characters(141)
          sub_put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
          expect(response).to have_http_status(422)
        end
      end

      context 'when description is nil' do
        it 'returns a 422' do
          body[:description] = nil
          sub_put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
          expect(response).to have_http_status(422)
        end
      end

      context 'when description is empty' do
        it 'returns a 422' do
          body[:description] = ''
          sub_put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
          expect(response).to have_http_status(422)
        end
      end

      context 'when terms is nil' do
        it 'returns a 422' do
          body[:terms] = nil
          sub_put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
          expect(response).to have_http_status(422)
        end
      end

      context 'when terms is empty' do
        it 'returns a 422' do
          body[:terms] = ''
          sub_put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
          expect(response).to have_http_status(422)
        end
      end

      context 'when stock was nil' do
        let!(:nil_stock_promo) { create(:promo_with_dates, stock: nil) }
        context 'and stock is zero' do
          it 'returns a 422' do
            body[:stock] = 0
            sub_put api_v1_promo_path(nil_stock_promo.id), { params: { promo: body } }
            expect(response).to have_http_status(422)
          end
        end
      end

      context 'when stock was not nil' do
        context 'and stock is nil' do
          context 'and end_date is nil' do
            it 'returns a 422' do
              body[:stock] = nil
              sub_put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
              expect(response).to have_http_status(422)
            end
          end

          context 'and end_date is not nil' do
            it 'returns a 200' do
              existing_promo = create :promo_with_dates
              body[:stock] = nil
              sub_put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
              expect(response).to have_http_status(200)
            end
          end
        end

        context 'and stock is zero' do
          it 'returns a 200' do
            body[:stock] = 0
            sub_put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
            expect(response).to have_http_status(200)
          end
        end
      end

      context 'when price is negative' do
        it 'returns a 422' do
          body[:price] = Faker::Number.negative
          sub_put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
          expect(response).to have_http_status(422)
        end
      end

      context 'when has already started' do
        let(:started_promo) { create(:promo_already_started) }
        context 'when start_date is before current date' do
          it 'returns a 422' do
            body[:start_date] = Faker::Number.between(2, 15).days.ago
            sub_put api_v1_promo_path(started_promo.id), { params: { promo: body } }
            expect(response).to have_http_status(422)
          end
        end

        context 'when start_date is equal to current date' do
          it 'returns a 422' do
            body[:start_date] = DateTime.now + 5.minutes
            sub_put api_v1_promo_path(started_promo.id), { params: { promo: body } }
            expect(response).to have_http_status(422)
          end
        end

        context 'when start_date is after current date' do
          it 'returns a 422' do
            body[:start_date] = Faker::Number.between(2, 15).days.from_now
            sub_put api_v1_promo_path(started_promo.id), { params: { promo: body } }
            expect(response).to have_http_status(422)
          end
        end
      end

      context 'when has not started yet' do
        context 'when start_date is before current date' do
          it 'returns a 422' do
            body[:start_date] = Faker::Number.between(2, 15).days.ago
            sub_put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
            expect(response).to have_http_status(422)
          end
        end

        context 'when start_date is equal to current date' do
          it 'returns a 200' do
            body[:start_date] = DateTime.now + 5.minutes
            sub_put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
            expect(response).to have_http_status(200)
          end
        end

        context 'when start_date is after current date' do
          it 'returns a 200' do
            body[:start_date] = Faker::Number.between(2, 15).days.from_now
            sub_put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
            expect(response).to have_http_status(200)
          end
        end
      end

      context 'when end_date is not nil but start_date is' do
        let(:existing_promo_with_dates) { create(:promo_with_dates) }
        it 'returns a 422' do
          body[:end_date] = Faker::Number.between(2, 15).days.from_now
          body[:start_date] = nil
          sub_put api_v1_promo_path(existing_promo_with_dates.id), { params: { promo: body } }
          expect(response).to have_http_status(422)
        end
      end

      context 'when end_date is before current date' do
        it 'returns a 422' do
          body[:end_date] = Faker::Number.between(2, 15).days.ago
          sub_put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
          expect(response).to have_http_status(422)
        end
      end

      context 'when end_date is equal to current date' do
        it 'returns a 200' do
          body[:start_date] = DateTime.now + 2.minutes
          body[:end_date] = DateTime.now + 5.minutes
          sub_put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
          expect(response).to have_http_status(200)
        end
      end

      context 'when end_date is after current date' do
        it 'returns a 200' do
          body[:start_date] = DateTime.now + 2.minutes
          body[:end_date] = Faker::Number.between(2, 15).days.from_now
          sub_put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
          expect(response).to have_http_status(200)
        end
      end

      context 'when start_date is before end_date' do
        it 'returns a 200' do
          body[:start_date] = Faker::Number.between(2, 15).days.from_now
          body[:end_date] = Faker::Number.between(17, 30).days.from_now
          sub_put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
          expect(response).to have_http_status(200)
        end
      end

      context 'when start_date is equal to before end_date' do
        it 'returns a 200' do
          body[:start_date] = Faker::Number.between(2, 15).days.from_now
          body[:end_date] = body[:start_date]
          sub_put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
          expect(response).to have_http_status(200)
        end
      end

      context 'when start_date is after end_date' do
        it 'returns a 422' do
          body[:start_date] = Faker::Number.between(17, 30).days.from_now
          body[:end_date] = Faker::Number.between(2, 15).days.from_now
          sub_put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
          expect(response).to have_http_status(422)
        end
      end

      context 'when end_date is nil' do
        context 'and stock was nil' do
          it 'returns a 422' do
            existing_promo = create :promo_with_dates, stock: nil
            body[:end_date] = nil
            sub_put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
            expect(response).to have_http_status(422)
          end
        end

        context 'and stock was not nil' do
          it 'returns a 200' do
            existing_promo = create :promo_with_dates
            body[:end_date] = nil
            sub_put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
            expect(response).to have_http_status(200)
          end
        end
      end

      context 'when the promo already have some associated branches' do
        let(:store) { create :store }
        before do
          rand(5..10).times do
            branch = create(:branch, store_id: store.id)
            existing_promo.branches.push(branch)
          end
        end
        let(:existing_ids) { existing_promo.branch_ids }

        context 'when branch_ids is nil' do
          it 'does not modify the associated branches' do
            body[:branch_ids] = nil
            sub_put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
            expect(response).to have_http_status(200)
            sub_get api_v1_promo_path(existing_promo.id), { params: { expand: :branches } }
            found_promo = JSON.parse(response.body)
            expect(found_promo['branches'].length).to eq existing_ids.count
            found_promo['branches'].each { |branch| expect(existing_ids).to include(branch['id']) }
          end
        end

        context 'when branch_ids is empty array' do
          it 'does not modify the associated branches' do
            body[:branch_ids] = []
            sub_put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
            expect(response).to have_http_status(200)
            sub_get api_v1_promo_path(existing_promo.id), { params: { expand: :branches } }
            found_promo = JSON.parse(response.body)
            expect(found_promo['branches'].length).to eq existing_ids.count
            found_promo['branches'].each { |branch| expect(existing_ids).to include(branch['id']) }
          end
        end

        context 'when branch_ids is present with some ids' do
          let(:branch_ids) do
            ids = []
            rand(5..10).times do
              branch = create(:branch, store_id: store.id)
              ids.push(branch.id)
            end
            ids
          end

          it 'sets the associated branches to the given ones' do
            body[:branch_ids] = branch_ids
            sub_put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
            expect(response).to have_http_status(200)
            sub_get api_v1_promo_path(existing_promo.id), { params: { expand: :branches } }
            found_promo = JSON.parse(response.body)
            expect(found_promo['branches'].length).to eq branch_ids.length
            found_promo['branches'].each { |branch| expect(branch_ids).to include(branch['id']) }
          end
        end
      end
    end

    context 'when updating a non-existing promo' do
      it 'raises a RecordNotFound' do # No way to get the 404.
        expect do
          sub_put api_v1_promo_path('non-existing-id')
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'DELETE /v1/promos' do
    context 'when deleting an existing promo' do
      let(:existing_promo) { create :promo }
      it 'returns a 200' do
        sub_delete api_v1_promo_path(existing_promo.id)
        expect(response).to have_http_status(200)
      end
    end

    context 'when deleting a non-existing promo' do
      it 'raises a RecordNotFound' do # No way to get the 404.
        expect do
          sub_delete api_v1_promo_path('non-existing-id')
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end

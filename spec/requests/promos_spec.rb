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

    context 'when end_date is before current date' do
      it 'returns a 422' do
        body[:end_date] = Faker::Number.between(2, 15).days.ago
        sub_post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(422)
      end
    end

    context 'when end_date is equal to current date' do
      it 'returns a 201' do
        body[:end_date] = DateTime.now + 5.minutes
        sub_post api_v1_promos_path, { params: { promo: body } }
        expect(response).to have_http_status(201)
      end
    end

    context 'when end_date is after current date' do
      it 'returns a 201' do
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
        let!(:nil_stock_promo) { create(:promo, stock: nil) }
        context 'and stock is zero' do
          it 'returns a 422' do
            body[:stock] = 0
            sub_put api_v1_promo_path(nil_stock_promo.id), { params: { promo: body } }
            expect(response).to have_http_status(422)
          end
        end
      end

      context 'when stock was not nil' do
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

      context 'when end_date is before current date' do
        it 'returns a 422' do
          body[:end_date] = Faker::Number.between(2, 15).days.ago
          sub_put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
          expect(response).to have_http_status(422)
        end
      end

      context 'when end_date is equal to current date' do
        it 'returns a 200' do
          body[:end_date] = DateTime.now + 5.minutes
          sub_put api_v1_promo_path(existing_promo.id), { params: { promo: body } }
          expect(response).to have_http_status(200)
        end
      end

      context 'when end_date is after current date' do
        it 'returns a 200' do
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

require 'rails_helper'

RSpec.describe Promo, type: :model do
  it 'has a valid factory' do
    expect(build(:promo)).to be_valid
  end

  describe 'name' do
    context 'when nil' do
      it 'is invalid' do
        expect(build(:promo, name: nil)).not_to be_valid
      end
    end

    context 'when empty' do
      it 'is invalid' do
        expect(build(:promo, name: '')).not_to be_valid
      end
    end

    context 'with more than 140 characters' do
      it 'is invalid' do
        expect(build(:promo, name: Faker::Lorem.characters(141))).to be_invalid
      end
    end

    context 'with no more than 140 characters' do
      it 'is valid' do
        name = Faker::Lorem.characters(Faker::Number.between(1, 140)) # From 1 to 140 characters
        expect(build(:promo, name: name)).to be_valid
      end
    end
  end

  describe 'description' do
    context 'when nil' do
      it 'is invalid' do
        expect(build(:promo, description: nil)).not_to be_valid
      end
    end

    context 'when empty' do
      it 'is invalid' do
        expect(build(:promo, description: '')).not_to be_valid
      end
    end

    context 'when not empty' do
      it 'is valid' do
        expect(build(:promo)).to be_valid
      end
    end
  end

  describe 'terms' do
    context 'when nil' do
      it 'is invalid' do
        expect(build(:promo, terms: nil)).not_to be_valid
      end
    end

    context 'when empty' do
      it 'is invalid' do
        expect(build(:promo, terms: '')).not_to be_valid
      end
    end

    context 'when not empty' do
      it 'is valid' do
        expect(build(:promo)).to be_valid
      end
    end
  end

  describe 'stock' do
    context 'when nil' do
      it 'is valid' do
        expect(build(:promo, stock: nil)).to be_valid
      end
    end

    context 'with negative units' do
      let(:existing_promo) { create(:promo, stock: nil) }
      it 'is invalid' do
        expect(build(:promo, stock: Faker::Number.between(-99999, -1))).not_to be_valid
        existing_promo.stock = Faker::Number.between(-99999, -1)
        expect(existing_promo).not_to be_valid
      end
    end

    context 'with zero units' do
      context 'when new record' do
        it 'is invalid' do
          expect(build(:promo, stock: 0)).not_to be_valid
        end
      end

      context 'when not new record' do
        context 'and stock was nil' do
          let!(:existing_promo) { create(:promo, stock: nil) }
          it 'is invalid' do
            existing_promo.stock = 0
            expect(existing_promo).not_to be_valid
          end
        end

        context 'and stock was not nil' do
          let!(:existing_promo) { create(:promo, stock: 1) }
          it 'is valid' do
            existing_promo.stock -= 1
            expect(existing_promo).to be_valid
          end
        end
      end
    end
  end

  describe 'price' do
    context 'when nil' do
      it 'is valid' do
        expect(build(:promo, price: nil)).to be_valid
      end
    end

    context 'when negative' do
      it 'is invalid' do
        expect(build(:promo, price: Faker::Number.negative)).not_to be_valid
      end
    end

    context 'when zero' do
      it 'is valid' do
        expect(build(:promo, price: 0.0)).to be_valid
      end
    end

    context 'when positive' do
      it 'is valid' do
        expect(build(:promo, price: Faker::Number.positive)).to be_valid
      end
    end
  end

  describe 'start_date' do
    context 'when nil' do
      it 'is valid' do
        expect(build(:promo, start_date: nil)).to be_valid
      end
    end

    context 'when new record' do
      context 'and is before current date' do
        it 'is invalid' do
          expect(build(:promo, start_date: Faker::Number.between(1, 10).days.ago)).not_to be_valid
        end
      end

      context 'and is equals current date' do
        it 'is valid' do
          expect(build(:promo, start_date: DateTime.now + 2.minutes)).to be_valid
        end
      end

      context 'and is after current date' do
        it 'is valid' do
          expect(build(:promo, start_date: Faker::Number.between(1, 10).days.from_now)).to be_valid
        end
      end
    end

    context 'when not new record but changed state' do
      context 'and has already started' do
        let!(:started_promo) { create :promo_already_started }
        context 'and new date is before current date' do
          it 'is invalid (not modifiable)' do
            started_promo.start_date = Faker::Number.between(1, 10).days.ago
            expect(started_promo).not_to be_valid
          end
        end

        context 'and is equals current date' do
          it 'is invalid (not modifiable)' do
            started_promo.start_date = DateTime.now + 2.minutes
            expect(started_promo).not_to be_valid
          end
        end

        context 'and is after current date' do
          it 'is invalid (not modifiable)' do
            started_promo.start_date = Faker::Number.between(1, 10).days.from_now
            started_promo.end_date = Faker::Number.between(15, 20).days.from_now
            expect(started_promo).not_to be_valid
          end
        end
      end

      context 'and has not started yet' do
        let!(:existing_promo) { create :promo_with_dates }
        context 'and is before current date' do
          it 'is invalid' do
            existing_promo.start_date = Faker::Number.between(1, 10).days.ago
            expect(existing_promo).not_to be_valid
          end
        end

        context 'and is equals current date' do
          it 'is valid' do
            existing_promo.start_date = DateTime.now + 2.minutes
            expect(existing_promo).to be_valid
          end
        end

        context 'and is after current date' do
          it 'is valid' do
            existing_promo.start_date = Faker::Number.between(1, 10).days.from_now
            existing_promo.end_date = Faker::Number.between(15, 20).days.from_now
            expect(existing_promo).to be_valid
          end
        end
      end
    end

    context 'when not new record and did not change state' do
      let!(:existing_promo) { create :promo_with_dates }
      it 'is valid' do
        existing_promo.name = "Not affecting name"
        existing_promo.description = "Changing this won't affect anything"
        expect(existing_promo).to be_valid
      end
    end

    context 'when end_date is not nil' do
      let!(:promo) { build(:promo, end_date: 30.days.from_now) }
      context 'and is before end_date' do
        it 'is valid' do
          promo.start_date = Faker::Number.between(2, 28).days.from_now
          expect(promo).to be_valid
        end
      end

      context 'and is the same as end_date' do
        it 'is valid' do
          promo.start_date = promo.end_date
          expect(promo).to be_valid
        end
      end

      context 'and is after end_date' do
        it 'is invalid' do
          promo.start_date = Faker::Date.between(31.days.from_now, 60.days.from_now)
          expect(promo).not_to be_valid
        end
      end
    end
  end

  describe 'end_date' do
    context 'when nil' do
      it 'is valid' do
        expect(build(:promo, end_date: nil)).to be_valid
      end
    end

    context 'when new record' do
      context 'and is before current date' do
        it 'is invalid' do
          expect(build(:promo, end_date: Faker::Number.between(1, 10).days.ago)).not_to be_valid
        end
      end

      context 'and is equals current date' do
        it 'is valid' do
          expect(build(:promo, end_date: DateTime.now + 2.minutes)).to be_valid
        end
      end

      context 'and is after current date' do
        it 'is valid' do
          expect(build(:promo, end_date: Faker::Number.between(1, 10).days.from_now)).to be_valid
        end
      end
    end

    context 'when not new record but changed state' do
      let!(:existing_promo) { create :promo_with_dates }
      context 'and is before current date' do
        it 'is invalid' do
          existing_promo.end_date = Faker::Number.between(1, 10).days.ago
          expect(existing_promo).not_to be_valid
        end
      end

      context 'and is equals current date' do
        it 'is valid' do
          existing_promo.start_date = DateTime.now + 2.minutes
          existing_promo.end_date = DateTime.now + 3.minutes
          expect(existing_promo).to be_valid
        end
      end

      context 'and is after current date' do
        it 'is valid' do
          existing_promo.start_date = Faker::Number.between(1, 10).days.from_now
          existing_promo.end_date = Faker::Number.between(15, 20).days.from_now
          expect(existing_promo).to be_valid
        end
      end
    end

    context 'when not new record and did not change state' do
      let!(:existing_promo) { create :promo_with_dates }
      it 'is valid' do
        existing_promo.name = "Not affecting name"
        existing_promo.description = "Changing this won't affect anything"
        expect(existing_promo).to be_valid
      end
    end

    context 'when start_date is not nil' do
      let!(:promo) { build(:promo, start_date: 30.days.from_now) }
      context 'and is before start_date' do
        it 'is invalid' do
          promo.end_date = Faker::Number.between(2, 28).days.from_now
          expect(promo).not_to be_valid
        end
      end

      context 'and is the same as start_date' do
        it 'is valid' do
          promo.end_date = 30.days.from_now
          expect(promo).to be_valid
        end
      end

      context 'and is after start_date' do
        it 'is valid' do
          promo.end_date = Faker::Date.between(31.days.from_now, 60.days.from_now)
          expect(promo).to be_valid
        end
      end
    end
  end
end

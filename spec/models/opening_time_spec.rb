require 'rails_helper'

RSpec.describe OpeningTime, type: :model do
  it 'has a valid factory' do
    expect(build(:opening_time)).to be_valid
  end

  describe 'day' do
    context 'when nil' do
      it 'is invalid' do
        expect(build(:opening_time, day: nil)).not_to be_valid
      end
    end

    context 'when negative' do
      it 'is invalid' do
        expect(build(:opening_time, day: Faker::Number.negative.to_i)).not_to be_valid
      end
    end

    context 'when more than 6' do
      it 'is invalid' do
        expect(build(:opening_time, day: Faker::Number.between(7, 99999999999))).not_to be_valid
      end
    end

    context 'when is in range 0..6' do
      it 'is valid' do
        expect(build(:opening_time, day: Faker::Number.between(0, 6))).to be_valid
      end
    end
  end

  describe 'opens_at' do
    context 'when nil' do
      it 'is invalid' do
        expect(build(:opening_time, opens_at: nil)).not_to be_valid
      end
    end
  end

  describe 'closes_at' do
    context 'when nil' do
      it 'is invalid' do
        expect(build(:opening_time, closes_at: nil)).not_to be_valid
      end
    end
  end

  describe 'valid_from' do
    context 'when nil' do
      it 'is invalid' do
        expect(build(:opening_time, valid_from: nil)).not_to be_valid
      end
    end

    context 'when is after valid_through' do
      it 'is invalid' do
        valid_from = Faker::Number.between(2, 10).days.ago
        valid_through = Faker::Number.between(11, 20).days.ago
        expect(build(:opening_time, valid_from: valid_from,
          valid_through: valid_through)).not_to be_valid
      end
    end

    context 'when is before valid_from' do
      it 'is valid' do
        valid_from = Faker::Number.between(11, 20).days.ago
        valid_through = Faker::Number.between(2, 10).days.ago
        expect(build(:opening_time, valid_from: valid_from,
          valid_through: valid_through)).to be_valid
      end
    end
  end

  describe 'valid_through' do
    context 'when nil' do
      it 'is valid' do
        expect(build(:opening_time, valid_through: nil)).to be_valid
      end
    end

    context 'when is before valid_from' do
      it 'is invalid' do
        valid_from = Faker::Number.between(2, 10).days.ago
        valid_through = Faker::Number.between(11, 20).days.ago
        expect(build(:opening_time, valid_from: valid_from,
          valid_through: valid_through)).not_to be_valid
      end
    end

    context 'when is after valid_from' do
      it 'is valid' do
        valid_from = Faker::Number.between(11, 20).days.ago
        valid_through = Faker::Number.between(2, 10).days.ago
        expect(build(:opening_time, valid_from: valid_from,
          valid_through: valid_through)).to be_valid
      end
    end
  end

  describe 'branch' do
    context 'when nil' do
      it 'is invalid' do
        expect(build(:opening_time, branch_id: nil)).not_to be_valid
      end
    end

    context 'when empty' do
      it 'is invalid' do
        expect(build(:opening_time, branch_id: '')).not_to be_valid
      end
    end

    context 'when does not exist' do
      it 'is invalid' do
        expect(build(:opening_time, branch_id: 'non-existing-id')).not_to be_valid
      end
    end
  end
end

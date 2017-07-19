require 'rails_helper'

RSpec.describe ContactInformation, type: :model do
  it 'has a valid factory' do
    expect(build(:contact_information)).to be_valid
  end

  describe 'key' do
    context 'when nil' do
      it 'is invalid' do
        expect(build(:contact_information, key: nil)).not_to be_valid
      end
    end

    context 'when empty' do
      it 'is invalid' do
        expect(build(:contact_information, key: '')).not_to be_valid
      end
    end

    context 'when not unique for the same store' do
      let(:existing) { create(:contact_information) }
      it 'is invalid' do
        expect(build(:contact_information, key: existing.key, store_id: existing.store_id))
          .not_to be_valid
      end
    end
  end

  describe 'value' do
    context 'when nil' do
      it 'is invalid' do
        expect(build(:contact_information, value: nil)).not_to be_valid
      end
    end

    context 'when empty' do
      it 'is invalid' do
        expect(build(:contact_information, value: '')).not_to be_valid
      end
    end
  end

  describe 'store' do
    context 'when nil' do
      it 'is invalid' do
        expect(build(:contact_information, store_id: nil)).not_to be_valid
      end
    end

    context 'when empty' do
      it 'is invalid' do
        expect(build(:contact_information, store_id: '')).not_to be_valid
      end
    end

    context 'when does not exist' do
      it 'is invalid' do
        expect(build(:contact_information, store_id: 'non-existing-id')).not_to be_valid
      end
    end
  end
end

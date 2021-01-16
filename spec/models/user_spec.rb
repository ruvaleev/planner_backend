# frozen_string_literal: true

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  it { is_expected.to have_many(:areas).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_uniqueness_of(:email) }

  context 'encrypting/decrypting password' do
    let(:password) { FFaker::Internet.password }
    let(:user) { create(:user, password: password) }

    describe '#encrypt_password' do
      it 'encrypts password before save' do
        expect(user.password).not_to eq password
      end
    end

    describe '#valid_password?' do
      let(:invalid_password) { FFaker::Internet.password }

      it 'returns true if provided password equal to saved decrypted password' do
        expect(user.valid_password?(password)).to be_truthy
      end

      it 'returns false if provided password equal to saved decrypted password' do
        expect(user.valid_password?(invalid_password)).to be_falsy
      end
    end
  end
end

# frozen_string_literal: true

require_relative 'concerns/models_shared_examples'

RSpec.describe Area, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:todos).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:title) }

  it_behaves_like 'representable', 'area', %w[id title created_at], %w[todos]

  describe '.fetch_for_user' do
    subject(:fetch_for_user) { described_class.fetch_for_user(user.id) }

    let(:user) { create(:user) }
    let(:areas) { create_list(:area, rand(2..3), user: user) }
    let!(:todos) { create_list(:todo, rand(2..3), area: areas.sample) }
    let!(:other_other_other_todos) { create_list(:todo, rand(2..3), area: areas.sample) }
    let(:other_users_areas) { create_list(:area, rand(2..3)) }
    let!(:other_users_todos) { create_list(:todo, rand(2..3), area: other_users_areas.sample) }

    it 'returns all areas and its todos only for current_user' do
      result = fetch_for_user.to_json

      expect(result).to include(*areas.map(&:title))
      expect(result).to include(*todos.map(&:title))
      expect(result).not_to include(*other_users_areas.map(&:title))
      expect(result).not_to include(*other_users_todos.map(&:title))
    end
  end
end

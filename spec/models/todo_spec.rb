# frozen_string_literal: true

require_relative 'concerns/models_shared_examples'

RSpec.describe Todo, type: :model do
  it { is_expected.to belong_to(:area) }
  it { is_expected.to validate_presence_of(:title) }

  it_behaves_like 'representable', 'todo', %w[id title completed created_at]
end

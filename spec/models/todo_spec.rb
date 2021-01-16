# frozen_string_literal: true

RSpec.describe Todo, type: :model do
  it { is_expected.to belong_to(:area) }
  it { is_expected.to validate_presence_of(:title) }
end

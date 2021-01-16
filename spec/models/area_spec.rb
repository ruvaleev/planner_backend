# frozen_string_literal: true

RSpec.describe Area, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:todos).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:title) }
end

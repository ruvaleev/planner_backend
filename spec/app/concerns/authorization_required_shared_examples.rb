# frozen_string_literal: true

require_relative 'responses_shared_examples'

RSpec.shared_examples 'authorization required' do
  context 'when unauthorized request' do
    let(:headers) { {} }

    it_behaves_like 'returns status', 401
  end
end

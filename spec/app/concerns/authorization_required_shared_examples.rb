# frozen_string_literal: true

require_relative 'responses_shared_examples'

RSpec.shared_examples 'request authorization required' do
  context 'when unauthorized request' do
    let(:headers) { {} }

    it_behaves_like 'returns status', 401
  end
end

RSpec.shared_examples 'user authorization required' do
  let(:headers) { authorized_headers('rack.session' => {}) }

  it_behaves_like 'returns status', 401
end

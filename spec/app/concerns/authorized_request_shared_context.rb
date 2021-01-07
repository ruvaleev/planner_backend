# frozen_string_literal: true

RSpec.shared_context 'authorized request' do
  let(:headers) { { 'HTTP_AUTHORIZATION' => "Bearer #{ENV['API_KEY']}" } }
end

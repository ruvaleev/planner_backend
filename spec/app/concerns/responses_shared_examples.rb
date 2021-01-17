# frozen_string_literal: true

RSpec.shared_examples 'returns status' do |status|
  it "returns status #{status}" do
    send_request
    expect(last_response.status).to eq status
  end
end

RSpec.shared_examples 'returns unauthorized error' do
  it_behaves_like 'returns status', 401

  it 'returns unauthorized error' do
    send_request
    expect(parsed_body['errors']).to eq ['Unauthorized']
  end
end

RSpec.shared_examples 'returns not found error' do
  it_behaves_like 'returns status', 404

  it 'returns Not Found' do
    send_request
    expect(parsed_body['errors']).to eq({ 'record' => 'Not Found' })
  end
end

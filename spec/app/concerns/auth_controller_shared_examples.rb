# frozen_string_literal: true

require_relative 'responses_shared_examples'

RSpec.shared_examples 'saves found user under new token in redis and return it in response' do
  it 'returns new token' do
    send_request
    expect($redis.get(parsed_body['auth_token'])).to eq user.id.to_s
  end

  it_behaves_like 'returns status', 200
end

RSpec.shared_examples 'clears provided token from redis' do
  it 'clears token from redis' do
    send_request
    expect($redis.get(token)).to be nil
  end
end

RSpec.shared_examples 'refreshes token and send it in response' do
  it_behaves_like 'saves found user under new token in redis and return it in response'
  it_behaves_like 'clears provided token from redis'
end

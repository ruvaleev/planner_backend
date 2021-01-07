# frozen_string_literal: true

require_relative 'concerns/auth_controller_shared_examples'
require_relative 'concerns/authorization_required_shared_examples'
require_relative 'concerns/authorized_request_shared_context'
require_relative 'concerns/responses_shared_examples'

describe App::AuthController, type: :request do
  include_context 'authorized request'

  describe 'GET /' do
    subject(:send_request) { get '/', params, headers }

    let(:user) { create(:user) }
    let(:token) { SecureRandom.hex }
    let(:params) { { token: token } }

    it_behaves_like 'authorization required'

    context 'when token is found in redis' do
      before { $redis.set(token, user.id) }

      it_behaves_like 'refreshes token and send it in response'
    end

    context 'when token is not found in redis' do
      before { send_request }

      it "doens't save provided token" do
        expect($redis.get(token)).to be nil
      end

      it_behaves_like 'returns unauthorized error'
    end
  end

  describe 'POST /' do
    subject(:send_request) { post '/', params, headers }

    let(:params) { { user: { email: email, password: password } } }
    let(:email) { FFaker::Internet.email }
    let(:password) { FFaker::Internet.password }

    context 'when email and password are correct' do
      let!(:user) { create(:user, email: email, password: password) }

      it_behaves_like 'saves found user under new token in redis and return it in response'
    end

    context 'when email is incorrect' do
      let!(:user) { create(:user, email: FFaker::Internet.email, password: password) }

      it_behaves_like 'returns unauthorized error'
    end

    context 'when password is incorrect' do
      let!(:user) { create(:user, email: email, password: FFaker::Internet.password) }

      it_behaves_like 'returns unauthorized error'
    end
  end

  describe 'DELETE /' do
    subject(:send_request) { delete '/', params, headers }

    let(:token) { SecureRandom.hex }
    let(:params) { { token: token } }

    it_behaves_like 'authorization required'

    context 'when token is found in redis' do
      before { $redis.set(token, SecureRandom.hex) }

      it_behaves_like 'returns status', 200
      it_behaves_like 'clears provided token from redis'
    end

    context 'when token is not found in redis' do
      it_behaves_like 'returns status', 200
      it_behaves_like 'clears provided token from redis'
    end
  end
end

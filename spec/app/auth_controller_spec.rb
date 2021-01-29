# frozen_string_literal: true

require_relative 'concerns/authorization_required_shared_examples'
require_relative 'concerns/authorized_request_shared_context'
require_relative 'concerns/responses_shared_examples'

describe App::AuthController, type: :request do
  include_context 'authorized request'
  include_context 'authorized user'

  describe 'GET /' do
    subject(:send_request) { get '/', params, headers }

    it_behaves_like 'request authorization required'
    it_behaves_like 'user authorization required'
    it_behaves_like 'returns status', 200
  end

  describe 'POST /' do
    subject(:send_request) { post '/', params, headers }

    let(:params) { { user: { email: email, password: password } } }
    let(:email) { FFaker::Internet.email }
    let(:password) { FFaker::Internet.password }

    context 'when email and password are correct' do
      let!(:user) { create(:user, email: email, password: password) }

      it 'saves found user id to session' do
        send_request
        expect(last_request.env['rack.session'][:user_id]).to eq user.id
      end
      it_behaves_like 'returns status', 200
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

    it_behaves_like 'request authorization required'
    it_behaves_like 'returns status', 200

    it 'clears session user id' do
      send_request
      expect(last_request.env['rack.session'][:user_id]).to eq nil
    end
  end
end

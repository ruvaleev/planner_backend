# frozen_string_literal: true

require_relative 'concerns/authorization_required_shared_examples'
require_relative 'concerns/authorized_request_shared_context'
require_relative 'concerns/responses_shared_examples'

describe App::UsersController, type: :request do
  include_context 'authorized request'

  describe 'POST /' do
    subject(:send_request) { post '/', params, headers }

    let(:user_params) { attributes_for(:user) }
    let(:params) { { user: user_params } }

    it_behaves_like 'request authorization required'

    context 'when params valid' do
      it_behaves_like 'returns status', 200

      it 'creates new user' do
        expect { send_request }.to change(User, :count).by(1)
      end

      it 'saves new user id to session' do
        send_request
        expect(last_request.env['rack.session'][:user_id]).to eq(User.last.id)
      end
    end

    context 'when user with such email already exists' do
      before { User.create(params[:user]) }

      it 'creates new user' do
        expect { send_request }.not_to change(User, :count)
      end

      it_behaves_like 'returns status', 403

      it 'returns error message in response' do
        send_request
        expect(parsed_body['errors']).to eq({ 'email' => ['has already been taken'] })
      end
    end
  end
end

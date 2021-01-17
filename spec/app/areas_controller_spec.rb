# frozen_string_literal: true

require_relative 'concerns/authorization_required_shared_examples'
require_relative 'concerns/authorized_request_shared_context'
require_relative 'concerns/responses_shared_examples'

describe App::AreasController, type: :request do
  include_context 'authorized request'
  include_context 'authorized user'

  describe 'GET /' do
    subject(:send_request) { get '/', params, headers }

    it_behaves_like 'request authorization required'
    it_behaves_like 'user authorization required'

    context 'when user has areas and todos' do
      let(:areas) { create_list(:area, rand(2..3), user: user) }
      let!(:todos) { create_list(:todo, rand(2..3), area: areas.sample) }
      let(:other_users_areas) { create_list(:area, rand(2..3)) }
      let!(:other_users_todos) { create_list(:todo, rand(2..3), area: other_users_areas.sample) }

      it 'returns all areas and its todos only for current_user' do
        send_request
        expect(last_response.body).to include(*areas.map(&:title))
        expect(last_response.body).to include(*todos.map(&:title))
        expect(last_response.body).not_to include(*other_users_areas.map(&:title))
        expect(last_response.body).not_to include(*other_users_todos.map(&:title))
      end
    end
  end

  describe 'POST /' do
    subject(:send_request) { post '/', params, headers }

    it_behaves_like 'request authorization required'
    it_behaves_like 'user authorization required'

    context 'when area has valid parameters' do
      let(:params) { { area: attributes_for(:area) } }

      it_behaves_like 'returns status', 200

      it 'creates new Area for current user' do
        expect { send_request }.to change(user.areas, :count).by(1)
      end

      it 'returns created area in response' do
        send_request
        expect(last_response.body).to include(params[:area][:title])
      end
    end

    context 'when area has invalid parameters' do
      let(:params) { { area: {} } }

      it "doesn't create new Area" do
        expect { send_request }.not_to change(Area, :count)
      end

      it_behaves_like 'returns status', 403

      it 'returns error message in response' do
        send_request
        expect(parsed_body['errors']).to eq({ 'title' => ["can't be blank"] })
      end
    end
  end
end

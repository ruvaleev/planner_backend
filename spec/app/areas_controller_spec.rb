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
end

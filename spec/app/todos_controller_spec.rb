# frozen_string_literal: true

require_relative 'concerns/authorization_required_shared_examples'
require_relative 'concerns/authorized_request_shared_context'
require_relative 'concerns/responses_shared_examples'

describe App::TodosController, type: :request do
  include_context 'authorized request'
  include_context 'authorized user'

  describe 'POST /' do
    subject(:send_request) { post '/', params, headers }

    it_behaves_like 'request authorization required'
    it_behaves_like 'user authorization required'

    context 'when area has valid parameters' do
      let(:params) { { todo: attributes_for(:todo), area_id: area.id } }
      let(:area) { create(:area, user: user) }

      it_behaves_like 'returns status', 200

      it 'creates new Todo for provided area' do
        expect { send_request }.to change(area.todos, :count).by(1)
      end

      it 'returns created todo in response' do
        send_request
        expect(last_response.body).to include(params[:todo][:title])
      end
    end

    context 'when todo has invalid parameters' do
      let(:params) { { todo: {}, area_id: area.id } }
      let(:area) { create(:area, user: user) }

      it "doesn't create new Todo" do
        expect { send_request }.not_to change(Todo, :count)
      end

      it_behaves_like 'returns status', 403

      it 'returns error message in response' do
        send_request
        expect(parsed_body['errors']).to eq({ 'title' => ["can't be blank"] })
      end
    end

    context 'when current_user has no such area' do
      let(:params) { { todo: attributes_for(:todo), area_id: area.id } }
      let(:area) { create(:area) }

      it "doesn't create new Todo" do
        expect { send_request }.not_to change(Todo, :count)
      end

      it_behaves_like 'returns not found error'
    end
  end

  describe 'PATCH /:id' do
    subject(:send_request) { patch "/#{todo.id}", params, headers }

    let(:params) { { area_id: area.id, todo: attributes_for(:todo) } }
    let(:area) { create(:area, user: user) }
    let(:old_attributes) { attributes_for(:todo) }
    let!(:todo) { create(:todo, area: area, **old_attributes) }

    it_behaves_like 'request authorization required'
    it_behaves_like 'user authorization required'

    context 'when params are valid' do
      it_behaves_like 'returns status', 200

      it 'updates todo' do
        send_request
        todo.reload
        params[:todo].each do |field, value|
          expect(todo.send(field)).to eq(value)
        end
      end
    end

    context 'when params are invalid' do
      let!(:area) { create(:area) }

      it_behaves_like 'returns not found error'

      it "doesn't update todo" do
        send_request
        todo.reload
        old_attributes.each do |field, value|
          expect(todo.send(field)).to eq(value)
        end
      end
    end
  end

  describe 'DELETE /:id' do
    subject(:send_request) { delete "/#{todo.id}", params, headers }

    let(:params) { { area_id: area.id } }
    let(:area) { create(:area, user: user) }
    let!(:todo) { create(:todo, area: area) }

    it_behaves_like 'request authorization required'
    it_behaves_like 'user authorization required'

    context 'when params are valid' do
      it_behaves_like 'returns status', 200

      it 'destroys todo' do
        expect { send_request }.to change(area.todos, :count).by(-1)
      end
    end

    context 'when params are invalid' do
      let!(:area) { create(:area) }

      it_behaves_like 'returns not found error'

      it "doesn't delete any Todo" do
        expect { send_request }.not_to change(Todo, :count)
      end
    end
  end
end

# frozen_string_literal: true

RSpec.shared_context 'authorized request' do
  let(:headers) { authorized_headers }
  let(:params) { {} }
end

RSpec.shared_context 'authorized user' do
  let(:headers) { authorized_headers('rack.session' => { user_id: user.id }) }
  let(:user) { create(:user) }
end

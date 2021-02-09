# frozen_string_literal: true

describe DemoDataResetterService do
  describe '#run' do
    subject(:run_service) { service.run }

    let(:service) { described_class.new }
    let(:demo_user_email) { service.user_params[:email] }
    let(:demo_user) { create(:user, email: demo_user_email) }

    context 'when demo user absent' do
      it 'creates demo user with appropriate email' do
        expect { run_service }.to change(User.where(email: demo_user_email), :count).by(1)
      end
    end

    context 'when demo user present' do
      it "doesn't create demo user" do
        demo_user
        expect { run_service }.not_to change(User, :count)
      end
    end

    context 'when demo user areas absent' do
      it 'creates areas for demo user' do
        expect { run_service }.to change { demo_user.reload.areas.size }.by(service.areas_params.size)
      end

      it 'creates todos for every demo area' do
        demo_user
        run_service
        sample_area = service.areas_params.sample
        user_area = demo_user.areas.find_by(title: sample_area[:title])
        expect(user_area.todos.map(&:title)).to eq(sample_area[:todos])
      end
    end

    context 'when user have some areas' do
      let!(:existing_area) { create(:area, user: demo_user) }

      it 'destroys old areas' do
        expect { run_service }.to change {
          demo_user.areas.find_by(id: existing_area.id)
        }.from(existing_area).to(nil)
      end

      it 'creates demo areas for demo user' do
        run_service
        expect(demo_user.areas.size).to eq(service.areas_params.size)
      end
    end
  end
end

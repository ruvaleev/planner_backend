# frozen_string_literal: true

describe DemoDataResetterWorker do
  describe '#perform' do
    subject(:perform_worker) { described_class.perform_async }

    let(:resetter_service_double) { instance_double(DemoDataResetterService) }

    after(testing: :inline) { Sidekiq::Testing.fake! }
    before(testing: :inline) do
      allow(DemoDataResetterService).to receive(:new).and_return(resetter_service_double)
      allow(resetter_service_double).to receive(:run)
      Sidekiq::Testing.inline!
    end

    it 'pushes job on the queue' do
      expect { perform_worker }.to change(described_class.jobs, :size).by(1)
    end

    it 'creates demo user with appropriate email', testing: :inline do
      perform_worker
      expect(resetter_service_double).to have_received(:run).once
    end
  end
end

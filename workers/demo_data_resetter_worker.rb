# frozen_string_literal: true

require 'sidekiq-scheduler'

class DemoDataResetterWorker
  include Sidekiq::Worker

  def perform
    DemoDataResetterService.new.run
  end
end

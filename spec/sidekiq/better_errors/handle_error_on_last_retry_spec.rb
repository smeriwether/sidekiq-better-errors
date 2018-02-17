require 'spec_helper'

RSpec.describe Sidekiq::BetterErrors::HandleErrorOnLastRetry do
  context 'on a successful worker' do
    it 'should not raise an error' do
      expect do
        Sidekiq::BetterErrors::HandleErrorOnLastRetry.new.call('some_worker', 'some_job', 'some_queue') { nil }
      end.not_to raise_error
    end
  end

  context 'on an unsuccessful worker' do
    context 'when on the last retry' do
      it 'should not clear the Sidekiq.error_handlers' do
        error_handlers = ['some_error_handler', 'some_other_error_handler']
        fake_sidekiq = create_fake_sidekiq_with_error_handlers(error_handlers.clone)

        expect do
          Sidekiq::BetterErrors::HandleErrorOnLastRetry
            .new(fake_sidekiq)
            .call('worker', { 'retry' => 2, 'retry_count' => 1 }, 'queue') { raise RuntimeError }
        end.to raise_error(RuntimeError)

        expect(fake_sidekiq.error_handlers).to eq(error_handlers)
      end
    end

    context 'when not on the last retry' do
      it 'should clear out the Sidekiq.error_handlers' do
        fake_sidekiq = create_fake_sidekiq_with_error_handlers

        expect do
          Sidekiq::BetterErrors::HandleErrorOnLastRetry
            .new(fake_sidekiq)
            .call('worker', { 'retry' => 2, 'retry_count' => 0 }, 'queue') { raise RuntimeError }
        end.to raise_error(RuntimeError)

        expect(fake_sidekiq.error_handlers).to be_empty
      end
    end
  end

  def create_fake_sidekiq_with_error_handlers(handlers = ['some_handler'])
    FakeSidekiq.new(handlers)
  end
end

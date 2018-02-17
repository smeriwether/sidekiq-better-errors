require 'spec_helper'

RSpec.describe Sidekiq::BetterErrors do
  it 'can be configured' do
    expect(Sidekiq::BetterErrors.configure).to be_a(Sidekiq::BetterErrors::Configuration)
  end

  it 'can be configured with error handlers' do
    handlers = ['some_handler']

    Sidekiq::BetterErrors.configure(handlers)

    expect(Sidekiq::BetterErrors.configuration.error_handlers).to eq(handlers)
  end

  it 'can be configured only once' do
    config1 = Sidekiq::BetterErrors.configure
    config2 = Sidekiq::BetterErrors.configure

    expect(config1).to eql(config2)
  end
end

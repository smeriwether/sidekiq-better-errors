require 'spec_helper'

RSpec.describe Sidekiq::BetterErrors::Configuration do
  it 'should set error handlers' do
    handlers = ['some_handler']
    config = Sidekiq::BetterErrors::Configuration.new(handlers)
    expect(config.error_handlers).to eq(handlers)
  end
end

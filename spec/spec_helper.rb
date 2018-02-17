require "bundler/setup"
require "sidekiq"
require "pry"

require "support/fake_sidekiq"

require "sidekiq/better_errors"
require "sidekiq/better_errors/handle_error_on_last_retry"
require "sidekiq/better_errors/configuration"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    Sidekiq::BetterErrors.reset!
  end
end

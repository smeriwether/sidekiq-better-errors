module Sidekiq
  module BetterErrors
    class << self
      attr_accessor :configuration
    end

    def self.configure(handlers = [])
      self.configuration ||= Sidekiq::BetterErrors::Configuration.new(handlers)
    end

    def self.reset!
      self.configuration = nil
    end
  end
end

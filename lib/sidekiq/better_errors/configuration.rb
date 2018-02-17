module Sidekiq
  module BetterErrors
    class Configuration
      attr_accessor :error_handlers

      def initialize(error_handlers)
        self.error_handlers = error_handlers
      end
    end
  end
end

module Sidekiq
  module BetterErrors
    class HandleErrorOnLastRetry
      def initialize(sidekiq = ::Sidekiq)
        @sidekiq = sidekiq
      end

      def call(worker, job, queue)
        begin
          set_error_handlers!(job)
          yield
        rescue => ex
          raise ex
        end
      end

      private

      def set_error_handlers!(job)
        create_configuration
        clear_sidekiq_error_handlers!
        handlers = handlers_for_current_job(job)
        set_sidekiq_error_handlers!(handlers)
      end

      def create_configuration
        Sidekiq::BetterErrors.configure(@sidekiq.error_handlers.clone)
      end

      def clear_sidekiq_error_handlers!
        @sidekiq.error_handlers.clear
      end

      def set_sidekiq_error_handlers!(handlers)
        handlers.each do |handler|
          @sidekiq.error_handlers << handler
        end
      end

      def handlers_for_current_job(job)
        if last_retry?(job)
          Sidekiq::BetterErrors.configuration.error_handlers
        else
          []
        end
      end

      def last_retry?(job)
        retry_count = job['retry_count'] || 0
        retries = job['retry'] || 0
        retries <= retry_count + 1
      end
    end
  end
end

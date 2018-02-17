class FakeSidekiq
  attr_accessor :error_handlers

  def initialize(error_handlers)
    self.error_handlers = error_handlers
  end
end

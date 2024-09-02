# frozen_string_literal: true

# This is a base class for all services in the application. It provides a common interface for all services and a way
# to call them.
class ApplicationService
  private_class_method :new
  def self.call(...)
    new(...).call
  end
end

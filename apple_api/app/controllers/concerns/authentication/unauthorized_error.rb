module Authentication
  class UnauthorizedError < StandardError
    def initialize(message = "Authentication required")
      super(message)
    end
  end
end

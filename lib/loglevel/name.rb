module Loglevel
  # Like a string, but it can safely instantiate a class from itself
  class Name
    extend Forwardable

    def_delegators :@string, :to_str, :==

    def to_class(exception_class)
      Object.const_get(self)
    rescue NameError => exception
      Loglevel::Exception.handle_bad_class(self, exception, exception_class)
    end

    private

    def initialize(string)
      @string = string
    end
  end
end

module MethodStack
  class << self
    def record_depth
      #subtract 1 for the current scope
      @depth = caller.length - 1 if caller.length - 1 > @depth
    end

    def max_depth
      @depth
    end

    def reset_depth
      @depth = 0
    end
  end
end

class Base
  def factorial(acc, n)
    MethodStack.record_depth
    return acc if n <= 1
    factorial acc * n, n - 1
  end

  def simple(n)
    return n if n <= 0
    simple(n - 1)
  end
end

class Recursed
  include Torc

  def factorial(acc, n)
    MethodStack.record_depth
    return acc if n <= 1
    recurse acc * n, n - 1
  end

  def simple(n)
    return n if n <= 0
    recurse n - 1
  end
end

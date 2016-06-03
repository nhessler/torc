module StackDepth
  def initialize(*)
    reset_depth
    super
  end

  def record_depth
    #subtract 1 for the current scope
    @depth = caller.length - 1 if caller.length - 1 > @depth
  end

  def max_depth
    @depth || 0
  end

  def reset_depth
    @depth = 0
  end
end

class Base
  include StackDepth

  def factorial(acc, n)
    record_depth
    return acc if n <= 1
    factorial acc * n, n - 1
  end

  def simple(n)
    return n if n <= 0
    simple(n - 1)
  end
end

class Recurring
  include StackDepth
  include Torc

  def factorial(acc, n)
    record_depth
    return acc if n <= 1
    recur acc * n, n - 1
  end

  def simple(n)
    return n if n <= 0
    recur n - 1
  end
end

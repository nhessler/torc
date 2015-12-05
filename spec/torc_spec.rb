require 'spec_helper'

describe Torc do
  it 'has a version number' do
    expect(Torc::VERSION).not_to be nil
  end

  describe '#recurse' do

    it "doesn't alter the answer of the original method" do
      MethodStack.reset_depth
      expect(Harness.factorial_recurse(1,20)).to eql(Harness.factorial_base(1,20))
    end

    it "keeps the stack from growing" do
      num = rand(100..200)

      MethodStack.reset_depth
      Harness.factorial_base(1,num)
      base_depth = MethodStack.max_depth

      MethodStack.reset_depth
      Harness.factorial_recurse(1,num)
      recurse_depth = MethodStack.max_depth

      recurse_max_stack_depth = 5
      expect(recurse_depth).to eql(base_depth - (num - recurse_max_stack_depth))
    end

    it "can solve problems that would normally cause stack overflows" do
      stack_size = `ulimit -s`.to_i
      expect(Harness.simple_recurse(stack_size * 2)).to eql(0)
    end
  end

  describe '#torc' do
    it "doesn't alter the answer of the original method" do
      MethodStack.reset_depth
      expect(Harness.factorial_recurse(1,20)).to eql(Harness.factorial_base(1,20))
    end

    it "keeps the stack from growing" do
      num = rand(100..200)

      MethodStack.reset_depth
      Harness.factorial_base(1,num)
      base_depth = MethodStack.max_depth

      MethodStack.reset_depth
      Harness.factorial_recurse(1,num)
      recurse_depth = MethodStack.max_depth

      recurse_max_stack_depth = 5
      expect(recurse_depth).to eql(base_depth - (num - recurse_max_stack_depth))
    end

    it "can solve problems that would normally cause stack overflows" do
      stack_size = `ulimit -s`.to_i
      expect(Harness.simple_recurse(stack_size * 2)).to eql(0)
    end

  end
end

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

class Harness
  extend Torc

  def self.factorial_base(acc, n)
    MethodStack.record_depth
    return acc if n <= 1
    factorial_base acc * n, n - 1
  end

  def self.factorial_recurse(acc, n)
    MethodStack.record_depth
    return acc if n <= 1
    recurse acc * n, n - 1
  end

  def self.simple_base(n)
    return n if n <= 0
    simple_base n - 1
  end

  def self.simple_recurse(n)
    return n if n <= 0
    recurse n - 1
  end
end

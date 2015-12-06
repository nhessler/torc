require 'spec_helper'

describe Torc do
  let(:base)     { Base.new }
  let(:recursed) { Recursed.new }
  let(:torced)   { Torced.new }
  let(:num)      { rand(100..200) }

  it 'has a version number' do
    expect(Torc::VERSION).not_to be nil
  end

  describe '#recurse' do
    it "doesn't alter the answer of the original method" do
      MethodStack.reset_depth
      expect(recursed.factorial(1,20)).to eql(base.factorial(1,20))
    end

    it "keeps the stack from growing" do
      MethodStack.reset_depth
      base.factorial(1, num)
      base_depth = MethodStack.max_depth

      MethodStack.reset_depth
      recursed.factorial(1, num)
      recursed_depth = MethodStack.max_depth

      recursed_max_stack_depth = 5
      expect(recursed_depth).to eql(base_depth - (num - recursed_max_stack_depth))
    end

    it "can solve problems that would normally cause stack overflows" do
      double_stack_size = `ulimit -s`.to_i * 2
      expect(recursed.simple(double_stack_size)).to eql(0)
    end
  end
end

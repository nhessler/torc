require 'spec_helper'

RSpec.describe Torc do
  let(:base)     { Base.new }
  let(:recursed) { Recursed.new }
  let(:torced)   { Torced.new }
  let(:num)      { rand(100..200) }

  it 'has a version number' do
    expect(Torc::VERSION).to be_a_kind_of String
  end

  describe '#recurse' do
    it "doesn't alter the answer of the original method" do
      expect(recursed.factorial(1,20)).to eql(base.factorial(1,20))
    end

    it "keeps the stack from growing" do
      base.factorial(1, num)
      recursed.factorial(1, num)

      recursed_max_stack_depth = 3
      expected_depth = base.max_depth - (num - recursed_max_stack_depth)
      expect(recursed.max_depth).to eql(expected_depth)
    end

    it "can solve problems that would normally cause stack overflows" do
      double_stack_size = `ulimit -s`.to_i * 2

      expect { base.simple(double_stack_size) }
        .to(raise_exception(SystemStackError))

      expect(recursed.simple(double_stack_size)).to eq(0)
    end

    it 'can apply recursion to multiple methods' do
      multiplier = Class.new {
        include Torc

        def double(n, acc=0)
          return acc if n <= 0
          recurse(n-1, acc+2)
        end

        def triple(n, acc=0)
          return acc if n <= 0
          recurse(n-1, acc+3)
        end
      }.new

      expect(multiplier.double(10)).to eq(20)

      expect(multiplier.triple( 9)).to eq(27)
      expect(multiplier.triple(10)).to eq(30)
      expect(multiplier.triple(11)).to eq(33)
    end

    it 'can call one recursive method from another' do
      actual = Class.new {
        include Torc

        def cascading_sum(n, acc=0)
          return acc if n <= 0
          recurse(n-1, acc+sum(n))
        end

        def sum(n, acc=0)
          return acc if n <= 0
          recurse(n-1, acc+n)
        end
      }.new.cascading_sum(3)

      expected = 3+2+1 +
                   2+1 +
                     1

      expect(actual).to eq(expected)
    end


    it 'can support recursive methods that call back and forth from each other' do
      actual = Class.new {
        include Torc
        def method1(n, acc=0)
          return acc if n <= 0
          tail_call :method2, n-1, acc+n
        end
        def method2(n, acc=0)
          return acc if n <= 0
          tail_call :method1, n-1, acc+n
        end
      }.new.method1(6)

      expect(actual).to eq(6+5+4+3+2+1)
    end

    it 'can be extended onto an object' do
      obj = Object.new.extend(Torc)
      def obj.double(n, acc=0)
        return acc if n <= 0
        recurse(n-1, acc+2)
      end
      expect(obj.double(5)).to eq(10)
    end

    it 'is unaffected by overriding initialize'
    it 'does not affect the superclass initialize'
  end
end

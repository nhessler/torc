require "torc/version"
require "binding_of_caller"

module Torc
  def self.extended(obj)
    obj.__send__ :torc_init
  end

  def initialize(*args)
    torc_init
    super
  end

  def tail_call(name, *args)
    if @_torc_state[:loop_stack].empty?
      recurse name, *args
    else
      @_torc_state[:swap_to] = [name, args]
      @_torc_state[:finished] = false
    end
  end

  def recurse(*args)
    name = binding.of_caller(1).eval('__method__')
    if @_torc_state[:loop_stack].last == name
      @_torc_state[:finished] = false
      return args
    else
      @_torc_state[:loop_stack].push name
      begin
        begin
          @_torc_state[:finished] = true
          args = __send__ name, *args
          if @_torc_state[:swap_to]
            name, args = @_torc_state[:swap_to]
            @_torc_state[:swap_to] = nil
          end
        end until @_torc_state[:finished]
        return args
      ensure
        @_torc_state[:loop_stack].pop
      end
    end
  end

  private

  def torc_init
    @_torc_state = {
      loop_stack: [],
      swap_to:    nil,
      finished:   true,
    }
  end
end

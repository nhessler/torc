require "torc/version"
require "binding_of_caller"

module Torc


  def Torc.included(basename)
    basename.class_eval do
      include Torc::InstanceMethods
    end
  end

  module InstanceMethods
    def recurse(*args)
      return [:recurse, args] if instance_variable_defined? :@caller
      begin
        @caller = binding.of_caller(1).eval('__method__')
        caller_args = [:start, args]
        loop do
          caller_args = __send__ @caller, *caller_args.last
          return caller_args unless caller_args.respond_to? :first
          return caller_args unless caller_args.first == :recurse
        end
      ensure
        remove_instance_variable :@caller if instance_variable_defined? :@caller
      end
    end
  end
end

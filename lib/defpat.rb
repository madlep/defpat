require "defpat/version"

module Defpat
  class NoPatternMatchError < StandardError; end

  class << self
    def included(base)
      base.extend(ClassMethods)
    end
  end

  module ClassMethods
    def defpat(m, *matching_args, &block)
      head = heads[m]
      unless head
        head = MethodHead.new(m)
        heads[m] = head
        define_method(m) do |*args|
          clause = self.class.heads[m].matching_clause(args)
          if clause
            clause.call(self, args)
          else
            raise NoPatternMatchError, [args]
          end
        end
      end
      head.add_clause(matching_args, block)
    end

    def heads
      @heads ||= {}
    end
  end

  class MethodHead
    def initialize(name)
      @name = name
      @clauses = []
    end

    def add_clause(args, block)
      @clauses << Clause.new(args, block)
    end

    def matching_clause(args)
      @clauses.find{|c| c.match?(args)}
    end
  end

  class Clause
    def initialize(args, block)
      @matching_args = args
      @block = block
    end

    def match?(other_args)
      if @matching_args.length != other_args.length
        return false
      else
        @matching_args.zip(other_args).all?{|a,b| a === b}
      end
    end

    def call(obj, args)
      obj.instance_exec(*args, &@block)
    end
  end
end

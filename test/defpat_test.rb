require "test_helper"
class Fib
  include Defpat

  defpat :fib, 0 do |_n|
    0
  end

  defpat :fib, 1 do |_n|
    1
  end

  defpat :fib, Object do |n|
    fib(n - 1) + fib(n - 2)
  end
end

describe Fib do
  before do
    @f = Fib.new
  end

  it "allows fibonacci sequence to be defined with pattern matches" do
    _(@f.fib(0)).must_equal 0
    _(@f.fib(1)).must_equal 1
    _(@f.fib(2)).must_equal 1
    _(@f.fib(3)).must_equal 2
    _(@f.fib(14)).must_equal 377
  end
end

class FizzBuzz
  include Defpat

  defpat :fizzbuzz, ->(x){x % 3 == 0 && x % 5 == 0} do |_n|
    "FizzBuzz"
  end

  defpat :fizzbuzz, ->(x){x % 3 == 0} do |_n|
    "Fizz"
  end

  defpat :fizzbuzz, ->(x){x % 5 == 0} do |_n|
    "Buzz"
  end

  defpat :fizzbuzz, Integer do |n|
    n
  end
end

describe FizzBuzz do
  before do
    @fb = FizzBuzz.new
  end

  it "allows fizzbuzz to be defined with pattern matches" do
    _(@fb.fizzbuzz(1)).must_equal 1
    _(@fb.fizzbuzz(2)).must_equal 2
    _(@fb.fizzbuzz(3)).must_equal "Fizz"
    _(@fb.fizzbuzz(5)).must_equal "Buzz"
    _(@fb.fizzbuzz(15)).must_equal "FizzBuzz"
  end

  it "can't be called with a non-matching pattern" do
    _(@fb.fizzbuzz("not a number", "or this")).must_equal :foobar
  end
end

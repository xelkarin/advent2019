#!/usr/bin/ruby
# frozen_string_literal: true

DATA = File.join([File.dirname(__FILE__), '..', 'data', 'input.txt']).freeze

class FuelCalc
  def initialize(data)
    case data
    when String
      @datafile = File.open(data, 'r')
    when File
      @datafile = data
    else
      raise TypeError, 'Expected a File or path name (String)'
    end
  end

  def calc_fuel(mass)
    (mass / 3) - 2
  end

  def sum_fuel
    sum = 0
    @datafile.each_line do |line|
      mass = line.strip.to_i
      sum += calc_fuel(mass)
    end
    sum
  end

  def required_fuel
    @required_fuel ||= sum_fuel
  end
end

calc = FuelCalc.new(DATA)
puts "Total fuel required: #{calc.required_fuel}"

#!/usr/bin/ruby
# frozen_string_literal: true

DATA = File.join([File.dirname(__FILE__), '..', 'data', 'input.txt']).freeze

class FuelCalc
  def initialize(data)
    case data
    when String
      @data = read_data(File.open(data, 'r'))
    when File
      @data = read_data(data)
    when Array
      @data = data
    when Integer
      @data = [data]
    else
      raise TypeError, 'Expected a path name (String), File, or Integer data'
    end
  end

  def required_fuel
    @required_fuel ||= sum_fuel
  end

  private

  def read_data(datafile)
    datafile.each_line.collect { |l| l.strip.to_i }
  end

  def calc_fuel(mass)
    calc_fuel_r(mass, 0)
  end

  def calc_fuel_r(mass, total)
    mass = mass / 3 - 2
    return total if mass <= 0

    calc_fuel_r(mass, total + mass)
  end

  def sum_fuel
    @data.reduce(0) { |sum, mass| sum + calc_fuel(mass) }
  end
end

calc = FuelCalc.new(DATA)
puts "Total fuel required: #{calc.required_fuel}"

#!/usr/bin/ruby
# frozen_string_literal: true

$LOAD_PATH.unshift('.')
require 'point'
require 'line_seg'
require 'wire'

DATA = File.join([File.dirname(__FILE__), '..', 'data', 'input.txt']).freeze

ORIGIN = Point.new(0, 0).freeze

wires = []
File.open(DATA, 'r').each_line do |line|
  wires.push(Wire.new(line.strip.split(',')))
end

distances = (wires[0] & wires[1]).collect { |p| [p, p - ORIGIN] }
distance = distances.min { |a, b| a[1] <=> b[1] }[1]
puts "Manhattan distance to nearest intersection: #{distance}"

steps = nil
points = distances.collect { |p, _d| p }
catch :break do
  wires[0].steps(points).each do |p1, d1|
    wires[1].steps(points).each do |p2, d2|
      next if p1 != p2

      sum = d1 + d2
      steps ||= sum
      steps = [steps, sum].min
    end
  end
end
puts "Combined steps to nearest intersection: #{steps}"

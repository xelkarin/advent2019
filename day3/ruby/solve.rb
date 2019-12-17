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
point, distance = distances.sort { |a, b| a[1] <=> b[1] }.first
puts "Manhattan distance to nearest intersection: #{distance}"

#!/usr/bin/ruby
# frozen_string_literal: true

LIB_PATH = File.join([File.dirname(__FILE__), '../../lib/ruby']).freeze
$LOAD_PATH.unshift(LIB_PATH)
require 'intcode'

DATA = File.join([File.dirname(__FILE__), '../data/input.txt']).freeze

cpu = IntcodeCPU.new(DATA)
cpu.run

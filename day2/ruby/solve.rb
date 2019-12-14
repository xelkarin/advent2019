#!/usr/bin/ruby
# frozen_string_literal: true

DATA = File.join([File.dirname(__FILE__), '..', 'data', 'input.txt']).freeze

class Intcode
  ADD  = 1
  MULT = 2
  HALT = 99

  def initialize(program)
    @pc = 0
    @r1 = 0
    @r2 = 0
    @ds = 0

    case program
    when String
      @mem = read_file(File.open(program, 'r'))
    when File
      @mem = read_file(program)
    when Array
      @mem = program
    else
      raise TypeError, 'Expected a path name (String), File, or Array of Integers'
    end
  end

  def run
    while @mem[@pc] != HALT do; exec; end
    @mem[0]
  end

  def patch(addr, value)
    @mem[addr] = value
  end

  private

  def read_file(file)
    file.read.strip.split(',').map(&:to_i)
  end

  def exec
    case @mem[@pc]
    when ADD
      load_operands
      @mem[@ds] = @mem[@r1] + @mem[@r2]
    when MULT
      load_operands
      @mem[@ds] = @mem[@r1] * @mem[@r2]
    end
  end

  def load_operands
    @r1 = @mem[@pc += 1]
    @r2 = @mem[@pc += 1]
    @ds = @mem[@pc += 1]
    @pc += 1
  end
end

cpu = Intcode.new(DATA)
cpu.patch(0x01, 0x0c)
cpu.patch(0x02, 0x02)
puts "Intcode return value: #{cpu.run}"

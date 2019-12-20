#!/usr/bin/ruby
# frozen_string_literal: true

DATA = File.join([File.dirname(__FILE__), '..', 'data', 'input.txt']).freeze

class CPU
  ADD  = 1
  MULT = 2
  HALT = 99

  def initialize(program)
    case program
    when String
      @data = read_file(File.open(program, 'r'))
    when File
      @data = read_file(program)
    when Array
      @data = program
    else
      raise TypeError, 'Expected a path name (String), File, or Array of Integers'
    end
    reset
  end

  def reset
    @pc = 0
    @r1 = 0
    @r2 = 0
    @ds = 0
    @mem = @data.clone
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

cpu = CPU.new(DATA)
cpu.patch(0x01, 0x0c)
cpu.patch(0x02, 0x02)
puts "CPU return value input 1202: #{cpu.run}"

count = 0
result = 0
catch :break do
  range = (0..99)
  range.each do |noun|
    range.each do |verb|
      count += 1
      cpu.reset
      cpu.patch(0x01, noun)
      cpu.patch(0x02, verb)
      if cpu.run == 19690720
        result = 100 * noun + verb
        throw :break
      end
    end
  end
end

puts "CPU input for 19690720: #{result}, discovered after #{count} iterations."

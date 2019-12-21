#!/usr/bin/ruby
# frozen_string_literal: true

DATA = File.join([File.dirname(__FILE__), '..', 'data', 'input.txt']).freeze
CPU_RESULT = 19690720

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

  def run_expect(value)
    range = (0..99)
    range.each do |noun|
      range.each do |verb|
        reset
        patch(0x01, noun)
        patch(0x02, verb)
        return [noun, verb] if run == value
      end
    end
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
puts "CPU return value for input 1202: #{cpu.run}"

noun, verb = cpu.run_expect(CPU_RESULT)
input = 100 * noun + verb
puts "CPU input for #{CPU_RESULT}: #{input}."

# frozen_string_literal: true
require 'scanf'

class OpCode
  ADD  = 1
  MULT = 2
  IN   = 3
  OUT  = 4
  HALT = 99

  attr_accessor :opcode, :operands, :modes, :size

  def initialize(ip, mem)
    @opcode, @modes = deconstruct_opcode(mem[ip])
    @size = op_size(@opcode)
    @operands = read_operands(mem, ip, @size - 1) if size > 1
  end

  def exec(mem)
    case self
    when ADD  then add_op(mem)
    when MULT then mult_op(mem)
    when IN   then input(mem)
    when OUT  then output(mem)
    end
  end

  def ==(other)
    case other
    when OpCode
      opcode == other.opcode
    when Integer
      opcode == other
    end
  end

  def ===(other)
    case other
    when OpCode
      opcode === other.opcode
    when Integer
      opcode === other
    end
  end

  private

  def deconstruct_opcode(code)
    opcode = code % 100
    modes = enum_modes(code)
    [opcode, modes]
  end

  def enum_modes(code)
    digits = code.digits
    size = digits.size
    digits.fill(0, size, 5 - size) if size < 5
    digits[2..4].collect do |i|
      case i
      when 0 then :mem
      when 1 then :imm
      end
    end
  end

  def op_size(code)
    case code
    when ADD, MULT then 4
    when IN, OUT   then 2
    when HALT      then 1
    end
  end

  def read_operands(mem, ip, size)
    mem[ip + 1, size]
  end

  def add_op(mem)
    modes[2] = :imm
    o1, o2, ds = load_operands(mem)
    mem[ds] = o1 + o2
  end

  def mult_op(mem)
    modes[2] = :imm
    o1, o2, ds = load_operands(mem)
    mem[ds] = o1 * o2
  end

  def input(mem)
    print '? '
    value = scanf('%d').first
    mem[operands[0]] = value
  end

  def output(mem)
    puts load_operands(mem)
  end

  def load_operands(mem)
    operands.zip(modes).collect do |val, mode|
      mode == :mem ? mem[val] : val
    end
  end
end

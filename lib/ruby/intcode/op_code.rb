# frozen_string_literal: true
require 'scanf'

class OpCode
  ADD  = 1
  MULT = 2
  IN   = 3
  OUT  = 4
  JNZ  = 5
  JZ   = 6
  STOL = 7
  STOE = 8
  HALT = 99

  attr_accessor :opcode, :modes, :size

  def initialize(opcode)
    @opcode, @modes = deconstruct_opcode(opcode)
    @size = op_size(@opcode)
  end

  def exec(ip, mem)
    case self
    when ADD  then add_op(ip, mem)
    when MULT then mult_op(ip, mem)
    when IN   then input(ip, mem)
    when OUT  then output(ip, mem)
    when JNZ  then jump_if_true(ip, mem)
    when JZ   then jump_if_false(ip, mem)
    when STOL then store_if_less(ip, mem)
    when STOE then store_if_equal(ip, mem)
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
    digits = (code / 100).digits
    size = digits.size
    digits.fill(0, size, 3 - size) if size < 3
    digits.collect do |i|
      case i
      when 0 then :mem
      when 1 then :imm
      end
    end
  end

  def op_size(code)
    case code
    when ADD, MULT,
         STOL, STOE then 4
    when JZ, JNZ    then 3
    when IN, OUT    then 2
    when HALT       then 1
    end
  end

  def read_operands(ip, mem)
    mem[ip + 1, size - 1]
  end

  def add_op(ip, mem)
    modes[2] = :imm
    val1, val2, addr = load_operands(ip, mem)
    mem[addr] = val1 + val2
    ip + size
  end

  def mult_op(ip, mem)
    modes[2] = :imm
    val1, val2, addr = load_operands(ip, mem)
    mem[addr] = val1 * val2
    ip + size
  end

  def input(ip, mem)
    print '? '
    val = scanf('%d').first
    operand = read_operands(ip, mem).first
    mem[operand] = val
    ip + size
  end

  def output(ip, mem)
    puts load_operands(ip, mem).first
    ip + size
  end

  def jump_if_true(ip, mem)
    val, addr = load_operands(ip, mem)
    val.zero? ? ip + size : addr
  end

  def jump_if_false(ip, mem)
    val, addr = load_operands(ip, mem)
    val.zero? ? addr : ip + size
  end

  def store_if_less(ip, mem)
    modes[2] = :imm
    val1, val2, addr = load_operands(ip, mem)
    mem[addr] = val1 < val2 ? 1 : 0
    ip + size
  end

  def store_if_equal(ip, mem)
    modes[2] = :imm
    val1, val2, addr = load_operands(ip, mem)
    mem[addr] = val1 == val2 ? 1 : 0
    ip + size
  end

  def load_operands(ip, mem)
    read_operands(ip, mem).zip(modes).collect do |val, mode|
      mode == :mem ? mem[val] : val
    end
  end
end

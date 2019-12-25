# frozen_string_literal: true

class IntcodeCPU
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
    @ip = 0
    @mem = @data.clone
  end

  def run
    while OpCode.new(@ip, @mem) != OpCode::HALT do; exec; end
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
    opcode = OpCode.new(@ip, @mem)
    @ip = opcode.exec
  end
end

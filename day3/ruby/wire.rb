# frozen_string_literal: true

class Wire
  def initialize(data)
    @vertices = []
    @vertices.push(Point.new(0, 0))
    data.each_with_index do |val, i|
      @vertices.push(@vertices[i] + val)
    end
  end

  def lines
    @lines ||= calc_line_segs
  end

  #
  # Find points where wires intersect
  #
  def &(other)
    ipoints = []
    lines.each do |l1|
      other.lines.each do |l2|
        point = l1 & l2
        next if point.nil?
        next if point.x.zero? && point.y.zero?

        ipoints.push(point)
      end
    end
    ipoints
  end

  private

  def calc_line_segs
    lines = []
    @vertices.each_index do |i|
      lines.push(LineSeg.new(@vertices[i], @vertices[i + 1]))
    end
    lines[0..-2]
  end
end

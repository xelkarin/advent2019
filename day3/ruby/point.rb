# frozen_string_literal: true

Point = Struct.new(:x, :y)

class Point
  #
  # Add two points together or add distance to a point.
  #
  def +(other)
    case other
    when Point
      Point.new(x + other.x, y + other.y)
    when String
      add_distance(other)
    else
      raise TypeError, 'Expected Point or String.'
    end
  end

  #
  # Calculate Manhattan distance between Points
  #
  def -(other)
    (x - other.x).abs + (y - other.y).abs
  end

  def ==(other)
    x == other.x && y == other.y
  end

  private

  def add_distance(trajectory)
    case trajectory
    when /D(\d+)/
      Point.new(x, y - $1.to_i)
    when /L(\d+)/
      Point.new(x - $1.to_i, y)
    when /R(\d+)/
      Point.new(x + $1.to_i, y)
    when /U(\d+)/
      Point.new(x, y + $1.to_i)
    else
      raise 'Invalid trajectory notation.'
    end
  end
end

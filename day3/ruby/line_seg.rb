# frozen_string_literal: true

LineSeg = Struct.new(:p1, :p2)

class LineSeg
  def &(other)
    find_intersection(self, other)
  end

  # Check if a point resides on a Horizontal or Vertical line segment.
  def contains(point)
    if p1.x == p2.x && p1.x == point.x
      y1, y2 = [p1.y, p2.y].sort
      return y1 <= point.y && point.y <= y2
    elsif p1.y == p2.y && p1.y == point.y
      x1, x2 = [p1.x, p2.x].sort
      return x1 <= point.x && point.x <= x2
    end
    false
  end

  def length
    self[1] - self[0]
  end

  private

  def find_intersection(l1, l2)
    d = calc_d(l1[0].x, l1[0].y, l1[1].x, l1[1].y,
               l2[0].x, l2[0].y, l2[1].x, l2[1].y)
    return nil if d.zero?

    tn = calc_tn(l1[0].x, l1[0].y, l2[0].x, l2[0].y, l2[1].x, l2[1].y)
    un = calc_un(l1[0].x, l1[0].y, l1[1].x, l1[1].y, l2[0].x, l2[0].y)

    t = tn / d.to_f
    u = -(un / d.to_f)

    calc_p(t, l1) if 0.0 <= t && t <= 1.0 &&
                     0.0 <= u && u <= 1.0
  end

  #
  # Calculate denominator
  #
  def calc_d(x1, y1, x2, y2, x3, y3, x4, y4)
    (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
  end

  #
  # Calculate numerator for `t`
  #
  def calc_tn(x1, y1, x3, y3, x4, y4)
    (x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)
  end

  #
  # Calculate numerator for `u`
  #
  def calc_un(x1, y1, x2, y2, x3, y3)
    (x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)
  end

  #
  # Calculate point from `t` and L1
  #
  def calc_p(t, l1)
    x = (l1[0].x + (t * (l1[1].x - l1[0].x))).to_i
    y = (l1[0].y + (t * (l1[1].y - l1[0].y))).to_i
    Point.new(x, y)
  end
end

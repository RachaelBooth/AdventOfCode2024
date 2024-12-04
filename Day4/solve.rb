# frozen_string_literal: true

INPUT_PATH = 'input.txt'

Coordinate = Data.define(:x, :y) do
  def +(other)
    return unless other.is_a?(self.class)

    Coordinate.new(x + other.x, y + other.y)
  end
end

def parse_grid
  lines = File.readlines(INPUT_PATH)

  x = Set.new
  m = Set.new
  a = Set.new
  s = Set.new

  j = 0
  while j < lines.length
    i = 0
    while i < lines[j].length
      case lines[j][i]
      when 'X'
        x.add(Coordinate.new(x: i, y: j))
      when 'M'
        m.add(Coordinate.new(x: i, y: j))
      when 'A'
        a.add(Coordinate.new(x: i, y: j))
      when 'S'
        s.add(Coordinate.new(x: i, y: j))
      end
      i += 1
    end
    j += 1
  end

  [x, m, a, s]
end

def part1
  x, m, a, s = parse_grid

  directions = [
    Coordinate.new(1, 0),
    Coordinate.new(-1, 0),
    Coordinate.new(0, 1),
    Coordinate.new(0, -1),
    Coordinate.new(1, 1),
    Coordinate.new(1, -1),
    Coordinate.new(-1, 1),
    Coordinate.new(-1, -1)
  ]
  count = 0

  x.each do |c|
    directions.each do |d|
      count += 1 if m.include?(c + d) && a.include?(c + d + d) && s.include?(c + d + d + d)
    end
  end

  count
end

def part2
  _x, m, a, s = parse_grid

  count = 0

  a.each do |c|
    if (m.include?(c + Coordinate.new(1, 1)) && s.include?(c + Coordinate.new(-1, -1))) || (s.include?(c + Coordinate.new(1, 1)) && m.include?(c + Coordinate.new(-1, -1))) # rubocop:disable Style/Next,Layout/LineLength
      if (m.include?(c + Coordinate.new(1, -1)) && s.include?(c + Coordinate.new(-1, 1))) || (s.include?(c + Coordinate.new(1, -1)) && m.include?(c + Coordinate.new(-1, 1))) # rubocop:disable Layout/LineLength,Style/SoleNestedConditional
        count += 1
      end
    end
  end

  count
end

puts 'Part 1'
puts part1
puts '---'
puts 'Part 2'
puts part2

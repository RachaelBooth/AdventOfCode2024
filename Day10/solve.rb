# frozen_string_literal: true

INPUT_PATH = 'input.txt'

Coordinate = Data.define(:x, :y) do
  def +(other)
    return unless other.is_a?(self.class)

    Coordinate.new(x + other.x, y + other.y)
  end

  def -(other)
    return unless other.is_a?(self.class)

    Coordinate.new(x - other.x, y - other.y)
  end
end

def parse_map
  lines = File.readlines(INPUT_PATH).map(&:strip)

  map = {}

  (0..9).each do |height|
    map[height] = Set.new
  end

  y = 0
  while y < lines.length
    x = 0
    while x < lines[y].length
      map[lines[y][x].to_i].add(Coordinate.new(x, y))
      x += 1
    end
    y += 1
  end

  map
end

def neighbours(location)
  Set[location + Coordinate.new(1, 0), location + Coordinate.new(0, 1), location + Coordinate.new(-1, 0),
      location + Coordinate.new(0, -1)]
end

def count_trails_for_trailhead(map, trailhead)
  current = {}
  current[trailhead] = 1
  next_height = 1
  while next_height <= 9
    next_values = {}
    current.each do |location, paths|
      map[next_height].intersection(neighbours(location)).each do |next_location|
        if next_values.key?(next_location)
          next_values[next_location] += paths
        else
          next_values[next_location] = paths
        end
      end
    end
    current = next_values
    next_height += 1
  end
  current
end

def score(map, trailhead)
  trails = count_trails_for_trailhead(map, trailhead)
  trails.size
end

def rating(map, trailhead)
  trails = count_trails_for_trailhead(map, trailhead)
  trails.values.sum
end

def part1
  map = parse_map
  trailheads = map[0]
  score = 0
  trailheads.each do |trailhead|
    score += score(map, trailhead)
  end
  score
end

def part2
  map = parse_map
  trailheads = map[0]
  rating = 0
  trailheads.each do |trailhead|
    rating += rating(map, trailhead)
  end
  rating
end

puts 'Part 1'
puts part1
puts '---'
puts 'Part 2'
puts part2

# frozen_string_literal: true

require 'set'

INPUT_PATH = 'input.txt'

Coordinate = Data.define(:x, :y) do
  def +(other)
    return unless other.is_a?(self.class)

    Coordinate.new(x + other.x, y + other.y)
  end
end

DIRECTIONS = {
  up: Coordinate.new(0, -1),
  down: Coordinate.new(0, 1),
  left: Coordinate.new(-1, 0),
  right: Coordinate.new(1, 0)
}.freeze

def turn_right(direction)
  case direction
  when DIRECTIONS[:up]
    DIRECTIONS[:right]
  when DIRECTIONS[:right]
    DIRECTIONS[:down]
  when DIRECTIONS[:down]
    DIRECTIONS[:left]
  when DIRECTIONS[:left]
    DIRECTIONS[:up]
  end
end

def parse_grid
  lines = File.readlines(INPUT_PATH)

  obstacles = Set.new
  guard = nil

  y = 0
  while y < lines.length
    x = 0
    while x < lines[y].length
      case lines[y][x]
      when '#'
        obstacles.add(Coordinate.new(x, y))
      when '^'
        guard = Coordinate.new(x, y)
      end
      x += 1
    end
    y += 1
  end

  max_x = x - 1
  max_y = y - 1

  [obstacles, guard, max_x, max_y]
end

def in_range?(position, max_x, max_y)
  position.x >= 0 && position.x <= max_x && position.y >= 0 && position.y <= max_y
end

def positions_in_path(obstacles, guard, max_x, max_y)
  visited = Set.new

  seen = {}

  current = guard
  direction = DIRECTIONS[:up]
  while in_range?(current, max_x, max_y)
    if visited.include?(current)
      if seen[current].include?(direction)
        # In loop
        return 'Loop'
      end

      seen[current].add(direction)
    else
      visited.add(current)
      seen[current] = Set[direction]
    end

    n = current + direction
    if obstacles.include?(n)
      n = current
      direction = turn_right(direction)
    end
    current = n
  end

  visited
end

def part1
  obstacles, guard, max_x, max_y = parse_grid
  positions_in_path(obstacles, guard, max_x, max_y).size
end

# Bit icky, takes longer than I'd like but not long enough to not give an answer so ah well
def part2
  obstacles, guard, max_x, max_y = parse_grid
  initial_path = positions_in_path(obstacles, guard, max_x, max_y)

  count = 0
  initial_path.each do |location|
    next if location == guard

    with_added_obstacle = Set[*obstacles]
    with_added_obstacle.add(location)

    count += 1 if positions_in_path(with_added_obstacle, guard, max_x, max_y) == 'Loop'
  end
  count
end

puts 'Part 1'
puts part1
puts '---'
puts 'Part 2'
puts part2

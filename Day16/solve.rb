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

LocationWithDirection = Data.define(:location, :direction) do
  def turn_clockwise
    LocationWithDirection.new(location, rotate_clockwise(direction))
  end

  def turn_anticlockwise
    LocationWithDirection.new(location, rotate_anticlockwise(direction))
  end

  def move
    LocationWithDirection.new(location + direction, direction)
  end
end

def parse
  lines = File.readlines(INPUT_PATH).map(&:strip)

  walls = Set.new
  start_tile = nil
  end_tile = nil

  y = 0
  while y < lines.length
    x = 0
    while x < lines[y].length
      case lines[y][x]
      when '#'
        walls.add(Coordinate.new(x, y))
      when 'S'
        start_tile = Coordinate.new(x, y)
      when 'E'
        end_tile = Coordinate.new(x, y)
      end
      x += 1
    end
    y += 1
  end
  [walls, start_tile, end_tile]
end

NORTH = Coordinate.new(0, -1)
EAST = Coordinate.new(1, 0)
SOUTH = Coordinate.new(0, 1)
WEST = Coordinate.new(-1, 0)

def rotate_clockwise(direction)
  case direction
  when NORTH
    EAST
  when EAST
    SOUTH
  when SOUTH
    WEST
  when WEST
    NORTH
  end
end

def rotate_anticlockwise(direction)
  case direction
  when NORTH
    WEST
  when WEST
    SOUTH
  when SOUTH
    EAST
  when EAST
    NORTH
  end
end

# Should optimise this more, but I didn't
def find_best_paths(walls, start_tile, end_tile)
  current_states = [{ current: LocationWithDirection.new(start_tile, EAST), score: 0, route: Set.new }]
  seen = {}
  seen[LocationWithDirection.new(start_tile, EAST)] = 0
  best_finished_score = Float::INFINITY
  best_path_tiles = Set[end_tile]

  until current_states.empty?
    next_states = []
    current_states.each do |state|
      neighbours = [
        { current: state[:current].turn_clockwise, score: state[:score] + 1000, route: state[:route] + [state[:current].location] },
        { current: state[:current].turn_anticlockwise, score: state[:score] + 1000, route: state[:route] + [state[:current].location] },
        { current: state[:current].move, score: state[:score] + 1, route: state[:route] + [state[:current].location] }
      ]
      neighbours.each do |neighbour|
        next if walls.include?(neighbour[:current].location)

        if neighbour[:current].location == end_tile
          if neighbour[:score] < best_finished_score
            best_finished_score = neighbour[:score]
            best_path_tiles = neighbour[:route] + [end_tile]
          elsif neighbour[:score] == best_finished_score
            best_path_tiles += neighbour[:route]
          end
        elsif neighbour[:score] < best_finished_score
          if !seen.key?(neighbour[:current]) || seen[neighbour[:current]] >= neighbour[:score]
            seen[neighbour[:current]] = neighbour[:score]
            next_states.push(neighbour)
          end
        end
      end
    end
    current_states = next_states
  end

  [best_finished_score, best_path_tiles]
end

walls, start_tile, end_tile = parse
best_finished_score, best_path_tiles = find_best_paths(walls, start_tile, end_tile)

puts 'Part 1'
puts best_finished_score
puts '---'
puts 'Part 2'
puts best_path_tiles.size

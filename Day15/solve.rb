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

  def times(scalar)
    Coordinate.new(x * scalar, y * scalar)
  end
end

def parse
  lines = File.readlines(INPUT_PATH).map(&:strip)

  map = { walls: Set.new, boxes: Set.new }
  movements = []

  in_map_section = true

  y = 0
  while y < lines.length
    if lines[y].empty?
      in_map_section = false
    elsif in_map_section
      x = 0
      while x < lines[y].length
        case lines[y][x]
        when 'O'
          map[:boxes].add(Coordinate.new(x, y))
        when '#'
          map[:walls].add(Coordinate.new(x, y))
        when '@'
          map[:robot] = Coordinate.new(x, y)
        end
        x += 1
      end
    else
      movements.push(*lines[y].chars)
    end
    y += 1
  end
  [map, movements]
end

def twice_as_wide(map)
  updated_map = { walls: Set.new, boxes_left: Set.new, boxes_right: Set.new }

  map[:walls].each do |wall|
    updated_map[:walls].add(Coordinate.new(wall.x * 2, wall.y))
    updated_map[:walls].add(Coordinate.new(wall.x * 2 + 1, wall.y))
  end

  map[:boxes].each do |box|
    updated_map[:boxes_left].add(Coordinate.new(box.x * 2, box.y))
    updated_map[:boxes_right].add(Coordinate.new(box.x * 2 + 1, box.y))
  end

  updated_map[:robot] = Coordinate.new(map[:robot].x * 2, map[:robot].y)

  updated_map
end

def movement_vector(move)
  case move
  when '^'
    Coordinate.new(0, -1)
  when 'v'
    Coordinate.new(0, 1)
  when '>'
    Coordinate.new(1, 0)
  when '<'
    Coordinate.new(-1, 0)
  end
end

def perform_move!(map, move)
  mv = movement_vector(move)

  potential_location = map[:robot] + mv
  box_count = 0
  while map[:boxes].include?(potential_location)
    potential_location += mv
    box_count += 1
  end

  # Can't move if this hits a wall
  return map if map[:walls].include?(potential_location)

  map[:boxes].add(map[:robot] + mv.times(box_count + 1))
  map[:boxes].delete(map[:robot] + mv)
  map[:robot] += mv
end

def perform_move_wide_boxes!(map, move)
  mv = movement_vector(move)

  return map if map[:walls].include?(map[:robot] + mv)

  if ['>', '<'].include?(move)
    potential_location = map[:robot] + mv

    boxes_to_move = { left: Set.new, right: Set.new }
    while map[:boxes_left].include?(potential_location) || map[:boxes_right].include?(potential_location)
      boxes_to_move[:left].add(potential_location) if map[:boxes_left].include?(potential_location)
      boxes_to_move[:right].add(potential_location) if map[:boxes_right].include?(potential_location)
      potential_location += mv
    end

    return map if map[:walls].include?(potential_location)

    boxes_to_move[:left].each do |b|
      map[:boxes_left].delete(b)
      map[:boxes_left].add(b + mv)
    end

    boxes_to_move[:right].each do |b|
      map[:boxes_right].delete(b)
      map[:boxes_right].add(b + mv)
    end

    map[:robot] += mv
    return map
  end

  potential_locations = Set[map[:robot] + mv]
  boxes_to_move = { left: Set.new, right: Set.new }

  reached_space = !map[:boxes_left].include?(map[:robot] + mv) && !map[:boxes_right].include?(map[:robot] + mv)

  until reached_space
    new_potential_locations_used = Set.new
    map[:boxes_left].intersection(potential_locations).each do |b|
      boxes_to_move[:left].add(b)
      boxes_to_move[:right].add(b + Coordinate.new(1, 0))
      new_potential_locations_used.add(b + mv)
      new_potential_locations_used.add(b + mv + Coordinate.new(1, 0))
    end

    map[:boxes_right].intersection(potential_locations).each do |b|
      boxes_to_move[:right].add(b)
      boxes_to_move[:left].add(b - Coordinate.new(1, 0))
      new_potential_locations_used.add(b + mv)
      new_potential_locations_used.add(b + mv - Coordinate.new(1, 0))
    end

    return map if map[:walls].intersect?(new_potential_locations_used)

    unless map[:boxes_left].intersect?(new_potential_locations_used) || map[:boxes_right].intersect?(new_potential_locations_used)
      reached_space = true
    end

    potential_locations = new_potential_locations_used
  end

  map[:robot] += mv
  # Either both or neither sholud be empty
  return map if boxes_to_move[:left].empty?

  map[:boxes_left] -= boxes_to_move[:left]
  map[:boxes_left] += (boxes_to_move[:left].map { |box| box + mv })

  map[:boxes_right] -= boxes_to_move[:right]
  map[:boxes_right] += (boxes_to_move[:right].map { |box| box + mv })

  map
end

def sum_box_gps_coordinates(map)
  map[:boxes].sum { |box| box.x + 100 * box.y }
end

def sum_box_gps_coordinates2(map)
  map[:boxes_left].sum { |box| box.x + 100 * box.y }
end

def part1
  map, movements = parse
  movements.each do |move|
    perform_move!(map, move)
  end
  sum_box_gps_coordinates(map)
end

def part2
  map, movements = parse
  map = twice_as_wide(map)
  movements.each do |move|
    perform_move_wide_boxes!(map, move)
  end

  sum_box_gps_coordinates2(map)
end

puts 'Part 1'
puts part1
puts '---'
puts 'Part 2'
puts part2

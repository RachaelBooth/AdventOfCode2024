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

  y = 0
  while y < lines.length
    x = 0
    while x < lines[y].length
      map[Coordinate.new(x, y)] = lines[y][x]
      x += 1
    end
    y += 1
  end

  [map, x - 1, y - 1]
end

def neighbours(location)
  Set[location + Coordinate.new(1, 0), location - Coordinate.new(1, 0), location + Coordinate.new(0, 1),
      location - Coordinate.new(0, 1)]
end

def neighbours_with_diagonals(location)
  Set[location + Coordinate.new(1, 0), location - Coordinate.new(1, 0), location + Coordinate.new(0, 1),
      location - Coordinate.new(0, 1), location + Coordinate.new(1, 1), location - Coordinate.new(1, 1), location + Coordinate.new(1, -1), location - Coordinate.new(1, -1)]
end

def neighbours_in_map(location, max_x, max_y)
  [
    (location + Coordinate.new(1, 0) if location.x < max_x),
    (location - Coordinate.new(1, 0) if location.x.positive?),
    (location + Coordinate.new(0, 1) if location.y < max_y),
    (location - Coordinate.new(0, 1) if location.y.positive?)
  ].compact
end

def partition_plots(map, max_x, max_y)
  plots = []

  covered = Set.new

  y = 0
  while y <= max_y
    x = 0
    while x <= max_x
      unless covered.include?(Coordinate.new(x, y))
        plot = Set[Coordinate.new(x, y)]

        unhandled_edges = Set[Coordinate.new(x, y)]
        until unhandled_edges.empty?
          new_edges = Set.new
          unhandled_edges.each do |edge|
            neighbours_in_map(edge, max_x, max_y).each do |neighbour|
              if map[neighbour] == map[edge] && !plot.include?(neighbour)
                plot.add(neighbour)
                new_edges.add(neighbour)
              end
            end
          end
          unhandled_edges = new_edges
        end

        plots.push(plot)
        covered.merge(plot)
      end
      x += 1
    end
    y += 1
  end

  plots
end

def area(plot)
  plot.size
end

def perimiter(plot)
  p = 0
  plot.each do |location|
    p += (neighbours(location) - plot).size
  end
  p
end

def is_corner(includes_first, includes_diagonal, includes_second)
  return true if !includes_first && !includes_second
  return true if includes_first && !includes_diagonal && includes_second

  false
end

def number_of_sides(plot)
  # Summing internal angles (/90)
  corners = 0
  plot.each do |location|
    up = plot.include?(location + Coordinate.new(0, -1))
    right = plot.include?(location + Coordinate.new(1, 0))
    down = plot.include?(location + Coordinate.new(0, 1))
    left = plot.include?(location + Coordinate.new(-1, 0))
    dur = plot.include?(location + Coordinate.new(1, -1))
    dul = plot.include?(location + Coordinate.new(-1, -1))
    ddr = plot.include?(location + Coordinate.new(1, 1))
    ddl = plot.include?(location + Coordinate.new(-1, 1))

    corners += 1 if is_corner(up, dur, right)
    corners += 1 if is_corner(right, ddr, down)
    corners += 1 if is_corner(down, ddl, left)
    corners += 1 if is_corner(left, dul, up)
  end

  corners
end

def part1
  map, max_x, max_y = parse_map
  plots = partition_plots(map, max_x, max_y)

  price = 0
  plots.each do |plot|
    price += (area(plot) * perimiter(plot))
  end
  price
end

def part2
  map, max_x, max_y = parse_map
  plots = partition_plots(map, max_x, max_y)

  price = 0
  plots.each do |plot|
    price += (area(plot) * number_of_sides(plot))
  end
  price
end

puts 'Part 1'
puts part1
puts '---'
puts 'Part 2'
puts part2

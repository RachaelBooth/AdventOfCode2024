# frozen_string_literal: true

require 'set'
require '../Helpers/modular_arithmetic'

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

def parse
  lines = File.readlines(INPUT_PATH)

  antennas = {}

  y = 0
  while y < lines.length
    x = 0
    while x < lines[y].length
      unless lines[y][x] == '.'
        if antennas.key?(lines[y][x])
          antennas[lines[y][x]].add(Coordinate.new(x, y))
        else
          antennas[lines[y][x]] = Set[Coordinate.new(x, y)]
        end
      end

      x += 1
    end
    y += 1
  end

  [antennas, x - 1, y - 1]
end

def in_range?(location, max_x, max_y)
  location.x >= 0 && location.x <= max_x && location.y >= 0 && location.y <= max_y
end

def find_antinodes1(antennas, max_x, max_y)
  antinodes = Set.new

  antennas.each_value do |antenna_group|
    antenna_group.each do |antenna|
      antenna_group.each do |other|
        next if other.x < antenna.x
        next if other.x == antenna.x && other.y <= antenna.y

        diff = antenna - other

        a = antenna + diff
        antinodes.add(a) if in_range?(a, max_x, max_y)

        b = other - diff
        antinodes.add(b) if in_range?(b, max_x, max_y)
      end
    end
  end

  antinodes
end

def find_antinodes2(antennas, max_x, max_y)
  antinodes = Set.new

  antennas.each_value do |antenna_group|
    antenna_group.each do |antenna|
      antenna_group.each do |other|
        next if other.x < antenna.x
        next if other.x == antenna.x && other.y <= antenna.y

        diff = antenna - other

        if diff.x.zero?
          diff = Coordinate.new(0, diff.y / diff.y.abs)
        elsif diff.y.zero?
          diff = Coordinate.new(diff.x / diff.x.abs, 0)
        else
          gcd, _s, _t = bezout_coefficients(diff.x.abs, diff.y.abs)
          diff = Coordinate.new(x / gcd, y / gcd) if gcd > 1
        end

        a = antenna
        while in_range?(a, max_x, max_y)
          antinodes.add(a)
          a += diff
        end

        b = antenna - diff
        while in_range?(b, max_x, max_y)
          antinodes.add(b)
          b -= diff
        end
      end
    end
  end

  antinodes
end

def part1
  antennas, max_x, max_y = parse
  antinodes = find_antinodes1(antennas, max_x, max_y)
  antinodes.size
end

def part2
  antennas, max_x, max_y = parse
  antinodes = find_antinodes2(antennas, max_x, max_y)
  antinodes.size
end

puts 'Part 1'
puts part1
puts '---'
puts 'Part 2'
puts part2

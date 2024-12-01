# frozen_string_literal: true

INPUT_PATH = 'input.txt'

def parse_lists
  lines = File.readlines(INPUT_PATH)
  left = []
  right = []
  lines.each do |line|
    parts = line.split('   ')
    left.append(parts[0].to_i)
    right.append(parts[1].to_i)
  end
  [left, right]
end

def get_pairs(left, right)
  sorted_left = left.sort
  sorted_right = right.sort
  [sorted_left, sorted_right].transpose
end

def part1
  left, right = parse_lists
  pairs = get_pairs(left, right)
  distance = 0
  pairs.each do |pair|
    distance += (pair[0] - pair[1]).abs
  end
  distance
end

def part2
  left, right = parse_lists
  similarity = 0
  left.each do |element|
    s = element * right.count(element)
    similarity += s
  end
  similarity
end

puts 'Part 1'
puts part1
puts '---'
puts 'Part 2'
puts part2

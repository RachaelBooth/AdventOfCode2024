# frozen_string_literal: true

INPUT_PATH = 'input.txt'

def part1
  input = File.read(INPUT_PATH)
  matches = input.scan(/mul\((\d+),(\d+)\)/)
  total = 0
  matches.each do |match|
    total += match[0].to_i * match[1].to_i
  end
  total
end

def part2
  input = File.read(INPUT_PATH)
  parts = input.split('do()')
  do_parts = parts.map { |p| p.split("don't()")[0] }
  total = 0

  do_parts.each do |part|
    matches = part.scan(/mul\((\d+),(\d+)\)/)
    matches.each do |match|
      total += match[0].to_i * match[1].to_i
    end
  end

  total
end

puts 'Part 1'
puts part1
puts '---'
puts 'Part 2'
puts part2

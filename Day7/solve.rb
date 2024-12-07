# frozen_string_literal: true

require 'set'

INPUT_PATH = 'input.txt'

def parse
  lines = File.readlines(INPUT_PATH)

  equations = []
  lines.each do |line|
    parts = line.split(': ')
    target = parts[0].to_i
    operands = parts[1].split(' ').map(&:to_i)
    equations.push({ target:, operands: })
  end

  equations
end

def can_fix_one?(equation)
  # Operators + and *

  target = equation[:target]
  options = Set[equation[:operands][0]]
  i = 1
  while i < equation[:operands].length
    val = equation[:operands][i]
    next_options = Set.new
    options.each do |option|
      sum = option + val
      next_options.add(sum) if sum <= target

      product = option * val
      next_options.add(product) if product <= target
    end

    return false if next_options.empty?

    options = next_options
    i += 1
  end

  options.include?(target)
end

def can_fix_two?(equation)
  # Operators + and * and string concat

  target = equation[:target]
  options = Set[equation[:operands][0]]
  i = 1
  while i < equation[:operands].length
    val = equation[:operands][i]
    next_options = Set.new
    options.each do |option|
      sum = option + val
      next_options.add(sum) if sum <= target

      product = option * val
      next_options.add(product) if product <= target

      concat = "#{option}#{val}".to_i
      next_options.add(concat) if concat <= target
    end

    return false if next_options.empty?

    options = next_options
    i += 1
  end

  options.include?(target)
end

def part1
  equations = parse
  calibration_result = 0
  equations.each do |equation|
    calibration_result += equation[:target] if can_fix_one?(equation)
  end
  calibration_result
end

def part2
  equations = parse
  calibration_result = 0
  equations.each do |equation|
    calibration_result += equation[:target] if can_fix_two?(equation)
  end
  calibration_result
end

puts 'Part 1'
puts part1
puts '---'
puts 'Part 2'
puts part2

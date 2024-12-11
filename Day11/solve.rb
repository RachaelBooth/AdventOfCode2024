# frozen_string_literal: true

INPUT_PATH = 'input.txt'

def parse
  line = File.read(INPUT_PATH).strip
  stones = Hash.new(0)
  line.split(' ').map(&:to_i).each do |stone|
    stones[stone] += 1
  end
  stones
end

def evolve(stones, blinks)
  current = stones

  t = 0
  while t < blinks
    new_stones = Hash.new(0)
    current.each do |stone, occurances|
      if stone.zero?
        new_stones[1] += occurances
      elsif stone.to_s.length.even?
        s = stone.to_s
        a = s[0, s.length / 2].to_i
        b = s[s.length / 2, s.length / 2].to_i
        new_stones[a] += occurances
        new_stones[b] += occurances
      else
        n = stone * 2024
        new_stones[n] += occurances
      end
    end
    current = new_stones
    t += 1
  end

  current
end

def part1
  stones = parse
  evolve(stones, 25).values.sum
end

def part2
  stones = parse
  evolve(stones, 75).values.sum
end

puts 'Part 1'
puts part1
puts '---'
puts 'Part 2'
puts part2

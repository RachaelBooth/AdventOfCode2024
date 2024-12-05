# frozen_string_literal: true

require 'set'

INPUT_PATH = 'input.txt'

def parse
  lines = File.readlines(INPUT_PATH)

  comparisons = {}
  updates = []
  rules_section = true

  lines.each do |line|
    if line.strip.empty?
      rules_section = false
    elsif rules_section
      lower, higher = line.strip.split('|')
      if comparisons.key?(higher)
        comparisons[higher].add(lower)
      else
        comparisons[higher] = Set[lower]
      end
    else
      pages = line.strip.split(',')
      updates.push(pages)
    end
  end

  [comparisons, updates]
end

def order(pages, comparisons)
  ordered = []
  remaining = pages.to_set

  while ordered.length < pages.length
    next_lowest = comparisons.select { |key, value| remaining.include?(key) && value.intersection(remaining).empty? }
    # If there is more than one, their order shouldn't matter
    ordered.push(*next_lowest.keys)
    remaining -= next_lowest.keys

    if next_lowest.empty?
      puts 'Problem'
      return
    end
  end

  ordered
end

def ordered?(pages, comparisons)
  i = 0
  while i < pages.length
    current = pages[i]
    return false unless comparisons[current].intersection(pages.drop(i + 1)).empty?

    i += 1
  end
  true
end

def part1
  comparisons, updates = parse
  sum = 0
  updates.each do |pages|
    sum += pages[(pages.length - 1) / 2].to_i if ordered?(pages, comparisons)
  end
  sum
end

def part2
  comparisons, updates = parse
  sum = 0
  updates.each do |pages|
    next if ordered?(pages, comparisons)

    ordered_pages = order(pages, comparisons)
    sum += ordered_pages[(pages.length - 1) / 2].to_i
  end
  sum
end

puts 'Part 1'
puts part1
puts '---'
puts 'Part 2'
puts part2

# frozen_string_literal: true

INPUT_PATH = 'input.txt'

def parse_reports
  lines = File.readlines(INPUT_PATH)
  lines.map { |line| line.split(' ').map(&:to_i) }
end

def safe?(report)
  increasing = report[0] < report[1]

  (0..(report.length - 2)).each do |i|
    s = increasing ? report[i] : report[i + 1]
    l = increasing ? report[i + 1] : report[i]

    return false if s >= l
    return false if l - s > 3
  end
  true
end

def safe_with_single_removal?(report)
  return true if safe?(report)

  # Should be able to do this more efficiently, but ah well
  (0..(report.length - 1)).each do |i|
    t = report.dup
    t.delete_at(i)
    return true if safe?(t)
  end
  false
end

def part1
  reports = parse_reports
  reports.count { |report| safe?(report) }
end

def part2
  reports = parse_reports
  reports.count { |report| safe_with_single_removal?(report) }
end

puts 'Part 1'
puts part1
puts '---'
puts 'Part 2'
puts part2

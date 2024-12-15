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

  def %(other)
    return unless other.is_a?(self.class)

    Coordinate.new(x % other.x, y % other.y)
  end

  def times(scalar)
    Coordinate.new(x * scalar, y * scalar)
  end
end

def parse
  lines = File.readlines(INPUT_PATH)

  robots = []
  lines.each do |line|
    parts = line.split(/=|,| /)
    position = Coordinate.new(parts[1].to_i, parts[2].to_i)
    velocity = Coordinate.new(parts[4].to_i, parts[5].to_i)
    robots.push({ position:, velocity: })
  end

  robots
end

SPACE_SIZE = Coordinate.new(101, 103)

def take_steps(robots, steps)
  final = []
  robots.each do |robot|
    position = (robot[:position] + robot[:velocity].times(steps)) % SPACE_SIZE
    final.push({ position:, velocity: robot[:velocity] })
  end
  final
end

def safety_factor(robots)
  ul = 0
  ur = 0
  dl = 0
  dr = 0

  mid_x = (SPACE_SIZE.x - 1) / 2
  mid_y = (SPACE_SIZE.y - 1) / 2

  robots.each do |robot|
    if robot[:position].x < mid_x && robot[:position].y < mid_y
      ul += 1
    elsif robot[:position].x < mid_x && robot[:position].y > mid_y
      dl += 1
    elsif robot[:position].x > mid_x && robot[:position].y < mid_y
      ur += 1
    elsif robot[:position].x > mid_x && robot[:position].y > mid_y
      dr += 1
    end
  end

  ul * ur * dl * dr
end

def robot_positions(robots)
  robots.map { |robot| robot[:position] }.to_set
end

def draw(robot_positions)
  y = 0
  while y < SPACE_SIZE.y
    line = ''
    x = 0
    while x < SPACE_SIZE.x
      line += if robot_positions.include?(Coordinate.new(x, y))
                '#'
              else
                '.'
              end
      x += 1
    end
    puts line
    y += 1
  end
end

def part1
  robots = parse
  after_100_steps = take_steps(robots, 100)
  safety_factor(after_100_steps)
end

def part2
  # Try showing position with highest/lowest safety factor
  robots = parse
  max_positions = SPACE_SIZE.x * SPACE_SIZE.y
  min_safety_factor = safety_factor(robots)
  min_safety_factor_at = 0
  max_safety_factor = min_safety_factor
  max_safety_factor_at = 0
  results = { 0 => robot_positions(robots) }
  current = robots
  t = 1
  while t < max_positions
    new_robots = take_steps(current, 1)
    safety_factor = safety_factor(new_robots)
    results[t] = robot_positions(new_robots)
    if safety_factor > max_safety_factor
      max_safety_factor = safety_factor
      max_safety_factor_at = t
    end
    if safety_factor < min_safety_factor
      min_safety_factor = safety_factor
      min_safety_factor_at = t
    end

    t += 1
    current = new_robots
  end
  puts "max safety factor at: #{max_safety_factor_at}"
  draw(results[max_safety_factor_at])

  puts "min safety factor at: #{min_safety_factor_at}"
  draw(results[min_safety_factor_at])
end

puts 'Part 1'
puts part1
puts '---'
puts 'Part 2'
puts part2

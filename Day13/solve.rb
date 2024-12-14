# frozen_string_literal: true

# a*q + b*r = c
# a*s + b*t = d
# q, r, s, t, c, d given, find a, b
#
# Matrix: ( q r ) * ( a ) = ( c )
#           s t       b       d
#
#
# inverse of ( q r ) = (1/(qt - rs)) * (  t -r )
#              s t                       -s  q
#
#
# ( a ) = inverse * ( c ) = (1/(qt - rs)) * ( ct - rd )
#   b                 d                       qd - cs
#
# i.e. a = (ct - rd) / (qt - rs), b = (qd - cs) / (qt - rs)
#
# No inverse, and no solution (or infinite solutions), if qt = rs
#
# If qt = rs, then
# a*qt + b*rt = ct
# a*rs + b*rt = dr
# if ct != dr then no solutions, else infinite solutions
# if so, a = c/q - b*r/q, want to minimise 3a + b = 3*c/q + (1 - 3r/q)b with both a and b non-negative integers - that's annoying, hopefully it won't happen

INPUT_PATH = 'input.txt'

Vector = Data.define(:x, :y) do
  def +(other)
    return unless other.is_a?(self.class)

    Vector.new(x + other.x, y + other.y)
  end
end

def parse
  lines = File.readlines(INPUT_PATH)

  machines = []

  i = 0
  while i < lines.length
    machine = {}
    a_line_parts = lines[i].split(/ |,|\+/)
    machine[:button_a] = Vector.new(a_line_parts[3].to_i, a_line_parts[6].to_i)
    b_line_parts = lines[i + 1].split(/ |,|\+/)
    machine[:button_b] = Vector.new(b_line_parts[3].to_i, b_line_parts[6].to_i)
    prize_line_parts = lines[i + 2].split(/ |,|=/)
    machine[:prize] = Vector.new(prize_line_parts[2].to_i, prize_line_parts[5].to_i)
    machines.push(machine)
    i += 4
  end

  machines
end

def tokens_to_win(machine)
  # With terminology from comment
  c = machine[:prize].x
  d = machine[:prize].y
  q = machine[:button_a].x
  r = machine[:button_b].x
  s = machine[:button_a].y
  t = machine[:button_b].y

  can_invert = q * t != r * s

  if can_invert
    # Unique solution
    denominator = q * t - r * s
    a_numerator = c * t - r * d
    return [false] if a_numerator % denominator != 0

    b_numerator = q * d - c * s
    return [false] if b_numerator % denominator != 0

    a = a_numerator / denominator
    b = b_numerator / denominator

    return [false] if a.negative? || b.negative?

    return [true, 3 * a + b]
  end

  return [false] if c * t != d * r

  puts 'Need to handle annoying case'
  [false]
end

def part1
  machines = parse
  tokens = 0
  machines.each do |machine|
    can_win, tokens_needed = tokens_to_win(machine)
    tokens += tokens_needed if can_win
  end
  tokens
end

def part2
  machines = parse
  tokens = 0
  machines.each do |machine|
    machine[:prize] = machine[:prize] + Vector.new(10_000_000_000_000, 10_000_000_000_000)
    can_win, tokens_needed = tokens_to_win(machine)
    tokens += tokens_needed if can_win
  end
  tokens
end

puts 'Part 1'
puts part1
puts '---'
puts 'Part 2'
puts part2

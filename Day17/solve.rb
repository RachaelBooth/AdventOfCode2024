# frozen_string_literal: true

INPUT_PATH = 'input.txt'

def parse
  lines = File.readlines(INPUT_PATH)

  register_a = lines[0].split(': ')[1].to_i
  register_b = lines[1].split(': ')[1].to_i
  register_c = lines[2].split(': ')[1].to_i

  program = lines[4].split(': ')[1].split(',').map(&:to_i)

  [register_a, register_b, register_c, program]
end

def run_program(initial_a, initial_b, initial_c, program)
  pointer = 0

  register_a = initial_a
  register_b = initial_b
  register_c = initial_c

  output = []

  until pointer.negative? || pointer >= program.length
    case program[pointer]
    when 0
      combo_operand = case program[pointer + 1]
                      when 0
                        0
                      when 1
                        1
                      when 2
                        2
                      when 3
                        3
                      when 4
                        register_a
                      when 5
                        register_b
                      when 6
                        register_c
                      end
      denominator = 2**combo_operand
      register_a = register_a.div(denominator) # integer division
      pointer += 2
    when 1
      register_b ^= program[pointer + 1]
      pointer += 2
    when 2
      combo_operand = case program[pointer + 1]
                      when 0
                        0
                      when 1
                        1
                      when 2
                        2
                      when 3
                        3
                      when 4
                        register_a
                      when 5
                        register_b
                      when 6
                        register_c
                      end
      register_b = combo_operand % 8
      pointer += 2
    when 3
      if register_a.zero?
        pointer += 2
      else
        pointer = program[pointer + 1]
      end
    when 4
      register_b ^= register_c
      pointer += 2
    when 5
      combo_operand = case program[pointer + 1]
                      when 0
                        0
                      when 1
                        1
                      when 2
                        2
                      when 3
                        3
                      when 4
                        register_a
                      when 5
                        register_b
                      when 6
                        register_c
                      end
      output.push(combo_operand % 8)
      pointer += 2
    when 6
      combo_operand = case program[pointer + 1]
                      when 0
                        0
                      when 1
                        1
                      when 2
                        2
                      when 3
                        3
                      when 4
                        register_a
                      when 5
                        register_b
                      when 6
                        register_c
                      end
      denominator = 2**combo_operand
      register_b = register_a.div(denominator) # integer division
      pointer += 2
    when 7
      combo_operand = case program[pointer + 1]
                      when 0
                        0
                      when 1
                        1
                      when 2
                        2
                      when 3
                        3
                      when 4
                        register_a
                      when 5
                        register_b
                      when 6
                        register_c
                      end
      denominator = 2**combo_operand
      register_c = register_a.div(denominator) # integer division
      pointer += 2
    end
  end

  output
end

def part1
  register_a, register_b, register_c, program = parse
  output = run_program(register_a, register_b, register_c, program)
  output.join(',')
end

def part2
  _register_a, register_b, register_c, program = parse
  # Notes
  # Halts once floor(A/8) = 0, so have range of things to check given length
  # B and C get reset each time - Can work backwards to narrow down!

  length_to_check = 1
  options = Set[0]
  while length_to_check <= program.length
    desired_output = program.slice(-length_to_check, length_to_check)
    next_options = Set.new
    options.each do |option|
      a = option * 8
      while a < (option + 1) * 8
        next_options.add(a) if run_program(a, register_b, register_c, program) == desired_output
        a += 1
      end
    end
    options = next_options
    length_to_check += 1
  end

  options.min
end

puts 'Part 1'
puts part1
puts '---'
puts 'Part 2'
puts part2

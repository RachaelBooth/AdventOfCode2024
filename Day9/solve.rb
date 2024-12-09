# frozen_string_literal: true

INPUT_PATH = 'input.txt'

def read_disk_map
  File.readlines(INPUT_PATH)[0].chars.map(&:to_i)
end

def move_blocks(disk_map)
  result = []

  i = 0
  j = disk_map.length - 1
  j_used = 0
  while i <= j
    if i.even?
      id = i / 2
      count = disk_map[i]
      count -= j_used if i == j
      count.times do
        result.push(id)
      end
    else
      disk_map[i].times do
        id = j / 2
        result.push(id)
        j_used += 1
        next unless j_used == disk_map[j]

        j -= 2
        j_used = 0
        return result if j < i
      end
    end
    i += 1
  end
  result
end

def find_first_indices_by_block(disk_map)
  first_indices = {}
  d = 0
  c = 0
  while d < disk_map.length
    first_indices[d] = c
    c += disk_map[d]
    d += 1
  end
  first_indices
end

def move_files(disk_map)
  first_indices = find_first_indices_by_block(disk_map)

  used_spaces = {}
  result = {}

  file = disk_map.length - 1
  while file >= 0
    id = file / 2
    length = disk_map[file]
    moved = false
    i = 1
    while i < file && !moved
      used_spaces[i] = 0 unless used_spaces.key?(i)

      already_used = used_spaces[i]

      if disk_map[i] - already_used >= length
        start_index = first_indices[i] + already_used
        (start_index...(start_index + length)).each do |l|
          result[l] = id
        end
        used_spaces[i] = already_used + length
        moved = true
      else
        i += 2
      end
    end

    unless moved
      start_index = first_indices[file]
      (start_index...(start_index + length)).each do |l|
        result[l] = id
      end
    end

    file -= 2
  end
  result
end

def checksum_from_array(filesystem)
  result = 0
  filesystem.each_with_index do |value, index|
    result += index * value
  end
  result
end

def checksum_from_hash(filesystem)
  result = 0
  filesystem.each do |key, value|
    result += key * value
  end
  result
end

def part1
  disk_map = read_disk_map
  compacted = move_blocks(disk_map)
  checksum_from_array(compacted)
end

def part2
  disk_map = read_disk_map
  compacted = move_files(disk_map)
  checksum_from_hash(compacted)
end

puts 'Part 1'
puts part1
puts '---'
puts 'Part 2'
puts part2

require 'set'

start_time = Time.now

test_run = false
input = File.readlines("input/day23#{test_run ? '_test' : ''}.txt", chomp: true)

elves = Set.new
input.each_with_index do |line, y|
  line.chars.each_with_index do |c, x|
    elves.add([x, y]) if c == '#'
  end
end

NEIGHBOURS = [[-1, -1], [0, -1], [1, -1], [-1, 0], [1, 0], [-1, 1], [0, 1], [1, 1]].freeze
DIRECTIONS = [
  [[-1, -1], [0, -1], [1, -1]],
  [[-1, 1], [0, 1], [1, 1]],
  [[-1, -1], [-1, 0], [-1, 1]],
  [[1, -1], [1, 0], [1, 1]],
].freeze

start_dir_index = 0
round = 1
loop do
  proposed_moves = {}
  elves.each do |current_location|
    x, y = current_location
    next unless NEIGHBOURS.any? { |dx, dy| elves.include?([x + dx, y + dy]) }

    4.times do |i|
      direction = DIRECTIONS[(start_dir_index + i) % 4]
      unless direction.any? { |dx, dy| elves.include?([x + dx, y + dy]) }
        new_location = [x + direction[1].first, y + direction[1].last]
        proposed_moves.merge!(new_location => current_location) { |_k, _v1, _v2| nil } # clear values for clashing keys
        break
      end
    end
  end

  break if proposed_moves.empty?

  proposed_moves.reject { |_k, v| v.nil? }.each do |new_location, current_location|
    elves.delete(current_location)
    elves.add(new_location)
  end
  start_dir_index = (start_dir_index + 1) % 4

  if round == 10
    xmin, xmax = elves.map(&:first).minmax
    ymin, ymax = elves.map(&:last).minmax

    puts "Part 1: #{(xmax - xmin + 1) * (ymax - ymin + 1) - elves.length}"
  end

  round += 1
end

puts "Part 2: #{round}"
puts "Exec time: #{Time.now - start_time}"

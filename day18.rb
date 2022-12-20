require 'set'

input = File.open('input/day18.txt').readlines.map(&:rstrip).map { |line| line.split(',').map(&:to_i) }

@cubes = Set.new(input)

NEIGHBOURS = [
  [-1, 0, 0],
  [1, 0, 0],
  [0, -1, 0],
  [0, 1, 0],
  [0, 0, -1],
  [0, 0, 1]
].freeze

def neighbours(cell)
  NEIGHBOURS.map { |offsets| (0..2).map { |i| cell[i] + offsets[i] } }
end

def exposed_sides(cube)
  neighbours(cube).reject { |n| @cubes.include?(n) }.size
end

puts "Part 1: #{@cubes.map { |c| exposed_sides(c) }.reduce(&:+)}"

range = (0..2).map { |i| @cubes.map { |c| c[i] }.minmax }

@exterior = Set.new
seed = range.map(&:first)
queue = [seed]
visited = Set.new(queue)
until queue.empty?
  next_queue = []
  queue.each do |c|
    @exterior << c
    neighbours(c).each do |cell|
      next if (0..2).any? { |index| cell[index] < range[index].first - 1 || cell[index] > range[index].last + 1 }
      next if visited.include?(cell)

      visited << cell
      next_queue << cell unless @cubes.include?(cell)
    end
  end
  queue = next_queue
end

def external_sides(cube)
  neighbours(cube).select { |n| @exterior.include?(n) }.size
end

puts "Part 2: #{@cubes.map { |c| external_sides(c) }.reduce(&:+)}"

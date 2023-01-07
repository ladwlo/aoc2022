# frozen_string_literal: true

input = 'input/day10.txt'

f = File.open(input, 'r')
lines = f.readlines.map(&:strip)
f.close

def draw_pixel(row, cycle, x)
  pos = (cycle - 1) % 40
  row << ((pos - x).abs <= 1 ? '#' : '.')
  return unless pos == 39

  puts row.join
  row.clear
end

sum = 0
cycle = 1
x = 1
row = []
lines.each do |line|
  data = line.split(' ')
  op = data.first
  val = data.last.to_i
  case op
  when 'addx'
    draw_pixel(row, cycle, x)
    cycle += 1
    sum += cycle * x if cycle % 40 == 20
    draw_pixel(row, cycle, x)
    cycle += 1
    x += val
    sum += cycle * x if cycle % 40 == 20
  when 'noop'
    draw_pixel(row, cycle, x)
    cycle += 1
    sum += cycle * x if cycle % 40 == 20
  end
end

puts sum

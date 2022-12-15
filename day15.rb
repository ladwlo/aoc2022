require 'set'

start_time = Time.now

input = 'input/day15.txt'
test_row = 2_000_000
# input = 'input/day15_test.txt'
# test_row = 10

lines = File.readlines(input).map(&:rstrip).map { |line| line.split(/Sensor at x=|, y=|: closest beacon is at x=/) }

report = lines.map do |line|
  sx = line[1].to_i
  sy = line[2].to_i
  bx = line[3].to_i
  by = line[4].to_i
  [sx, sy, bx, by]
end

xranges_at_test_row = []
beacons_at_test_row = Set.new

report.each do |sx, sy, bx, by|
  beacons_at_test_row.add(bx) if by == test_row
  d = (sx - bx).abs + (sy - by).abs
  dy = (test_row - sy).abs
  if dy <= d # sensor sees the test row
    dx = d - dy
    xranges_at_test_row << [sx - dx, sx + dx]
  end
end

xranges_at_test_row.sort_by!(&:first)

empty_count = 0
x1 = x2 = nil
xranges_at_test_row.each do |rx1, rx2|
  if x2 && rx1 <= x2 + 1 # ranges overlap or touch
    x2 = rx2 if rx2 > x2
  else
    empty_count += (x2 - x1 + 1) if x2
    x1 = rx1
    x2 = rx2
  end
end
empty_count += (x2 - x1 + 1) if x2
empty_count -= beacons_at_test_row.size

puts empty_count

# = part 2 =

max_coord = 2 * test_row

found = false
(0..max_coord).each do |y|
  xranges = []
  report.each do |sx, sy, bx, by|
    d = (sx - bx).abs + (sy - by).abs # distance from sensor to beacon
    dy = (y - sy).abs
    next unless dy <= d # test row y is close enough to this sensor

    dx = d - dy
    rx1 = sx - dx
    rx1 = 0 if rx1 < 0
    rx2 = sx + dx
    rx2 = max_coord if rx2 > max_coord
    xranges << [rx1, rx2] if rx1 <= rx2
  end
  xranges.sort_by!(&:first)
  x2 = nil
  xranges.each do |rx1, rx2|
    if x2 && rx1 <= x2 + 1 # ranges overlap or touch
      x2 = rx2 if rx2 > x2
    else # first range or gap found
      found = x2 ? rx1 - x2 == 2 : rx1 == 1
      if found
        puts (rx1 - 1) * 4_000_000 + y
        puts "y=#{y}"
        break
      end
      x2 = rx2
    end
  end
  break if found
end

puts "Exec time: #{Time.now - start_time}"

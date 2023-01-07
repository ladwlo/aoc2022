t0 = Process.clock_gettime(Process::CLOCK_MONOTONIC)

input = 'input/day12.txt'

f = File.open(input)
lines = f.readlines.map(&:rstrip).map(&:chars)
f.close

rows = lines.length
cols = lines[0].length

start_row = 0
start_col = 0
end_row = 0
end_col = 0
lines.each_with_index do |line, row|
  if line.include?('S')
    start_row = row
    start_col = line.index('S')
    line[start_col] = 'a'
  end
  if line.include?('E')
    end_row = row
    end_col = line.index('E')
    line[end_col] = 'z'
  end
end

puts "%.0f" % ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - t0) * 1000000)

NEIGHBOURS = [[-1, 0], [0, -1], [1, 0], [0, 1]].freeze

# visited = Array.new(rows) { Array.new(cols) { false } }
#
# q = Queue.new
# q << [start_row, start_col]
# visited[start_row][start_col] = true
# step = 0
# until q.empty?
#   next_q = Queue.new
#   until q.empty?
#     r, c = q.deq
#     if r == end_row && c == end_col
#       puts step
#       q.clear
#       next_q.clear
#       break
#     end
#     NEIGHBOURS.each do |step_r, step_c|
#       rn = r + step_r
#       cn = c + step_c
#       next if rn < 0 || rn >= rows || cn < 0 || cn >= cols || visited[rn][cn] || lines[rn][cn].ord - lines[r][c].ord > 1
#
#       visited[rn][cn] = true
#       next_q.enq([rn, cn])
#     end
#   end
#   q = next_q
#   step += 1
# end

# == part 2 ==

t0 = Process.clock_gettime(Process::CLOCK_MONOTONIC)

visited = Array.new(rows) { Array.new(cols) { false } }

q = Queue.new
q << [end_row, end_col]
visited[end_row][end_col] = true
step = 0
found2 = false
until q.empty?
  next_q = Queue.new
  until q.empty?
    r, c = q.deq
    if lines[r][c] == 'a'
      unless found2
        puts "part2: #{step}"
        found2 = true
      end
      if r == start_row && c == start_col
        puts "part1: #{step}"
        q.clear
        next_q.clear
        break
      end
    end
    NEIGHBOURS.each do |step_r, step_c|
      rn = r + step_r
      cn = c + step_c
      next if rn < 0 || rn >= rows || cn < 0 || cn >= cols || visited[rn][cn] || lines[rn][cn].ord - lines[r][c].ord < -1

      visited[rn][cn] = true
      next_q.enq([rn, cn])
    end
  end
  q = next_q
  step += 1
end

puts "%.0f" % ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - t0) * 1000000)
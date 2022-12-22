start_time = Time.now

FACING_RIGHT = 0
FACING_DOWN = 1
FACING_LEFT = 2
FACING_UP = 3

@increments = [[1, 0], [0, 1], [-1, 0], [0, -1]] # x,y changes for one step in the facing direction

@test_input = false

input = File.readlines("input/day22#{@test_input ? '_test' : ''}.txt", chomp: true)

h = input.length - 2
w = input[0..(h - 1)].map(&:length).max

@board = []
@row_ranges = []
@col_ranges = Array.new(w) { [h, -1] }

(0..(h - 1)).each do |r|
  row = input[r]
  @board.append(row)
  xmin = row.index(/\.|#/)
  xmax = row.rstrip.length - 1
  @row_ranges.append([xmin, xmax])
  (xmin..xmax).each do |x|
    col_range = @col_ranges[x]
    col_range[0] = [col_range[0], r].min
    col_range[1] = [col_range[1], r].max
  end
end

@path = input.last

def wrap_around_part1(x, y, next_x, next_y)
  row_range = @row_ranges[y]
  col_range = @col_ranges[x]
  if next_x < row_range[0]
    next_x = row_range[1]
  elsif next_x > row_range[1]
    next_x = row_range[0]
  elsif next_y < col_range[0]
    next_y = col_range[1]
  elsif next_y > col_range[1]
    next_y = col_range[0]
  end
  [next_x, next_y]
end

def wrap_around_part2_test(prev_x, prev_y, x, y, f)
  col_range = @col_ranges[prev_x]
  row_range = @row_ranges[prev_y]
  d = @row_ranges.length / 3
  if x < row_range[0]
    x, y, f = case y / d
              when 0
                [d + y - 1, d, FACING_DOWN]
              when 1
                [5 * d - y, 3 * d - 1, FACING_UP]
              when 2
                [4 * d - y, 2 * d - 1, FACING_UP]
              end
  elsif x > row_range[1]
    x, y, f = case y / d
              when 0
                [4 * d - 1, 3 * d - y, FACING_LEFT]
              when 1
                [5 * d - y, 2 * d, FACING_DOWN]
              when 2
                [3 * d - 1, 3 * d - y, FACING_LEFT]
              end
  elsif y < col_range[0]
    x, y, f = case x / d
              when 0
                [3 * d - x, 0, FACING_DOWN]
              when 1
                [2 * d, x - d - 1, FACING_RIGHT]
              when 2
                [3 * d - x, d, FACING_LEFT]
              when 3
                [3 * d - 1, 5 * d - x, FACING_LEFT]
              end
  elsif y > col_range[1]
    x, y, f = case x / d
              when 0
                [3 * d - x, 3 * d - 1, FACING_UP]
              when 1
                [2 * d, 4 * d - x, FACING_RIGHT]
              when 2
                [3 * d - x, 2 * d - 1, FACING_UP]
              when 3
                [0, 5 * d - x, FACING_RIGHT]
              end
  end
  [x, y, f]
end

def wrap_around_part2(prev_x, prev_y, x, y, f)
  col_range = @col_ranges[prev_x]
  row_range = @row_ranges[prev_y]
  d = @row_ranges.length / 4
  if x < row_range[0]
    x, y, f = case prev_y / d
              when 0
                [0, 3 * d - y - 1, FACING_RIGHT]
              when 1
                [y - d, 2 * d, FACING_DOWN]
              when 2
                [d, 3 * d - y - 1, FACING_RIGHT]
              when 3
                [y - 2 * d, 0, FACING_DOWN]
              end
  elsif x > row_range[1]
    x, y, f = case prev_y / d
              when 0
                [2 * d - 1, 3 * d - y - 1, FACING_LEFT]
              when 1
                [d + y, d - 1, FACING_UP]
              when 2
                [3 * d - 1, 3 * d - y - 1, FACING_LEFT]
              when 3
                [y - 2 * d, 3 * d - 1, FACING_UP]
              end
  elsif y < col_range[0]
    x, y, f = case prev_x / d
              when 0
                [d, d + x, FACING_RIGHT]
              when 1
                [0, 2 * d + x, FACING_RIGHT]
              when 2
                [x - 2 * d, 4 * d - 1, FACING_UP]
              end
  elsif y > col_range[1]
    x, y, f = case x / d
              when 0
                [x + 2 * d, 0, FACING_DOWN]
              when 1
                [d - 1, x + 2 * d, FACING_LEFT]
              when 2
                [2 * d - 1, x - d, FACING_LEFT]
              end
  end
  [x, y, f]
end

def move(pos, steps, part)
  x, y, f = pos.values_at(:x, :y, :f)
  steps.times do
    inc_x, inc_y = @increments[f]
    next_x, next_y, next_f = [x + inc_x, y + inc_y, f]
    # apply the correct wrap-around if moving beyond an edge
    case part
    when 1
      next_x, next_y = wrap_around_part1(x, y, next_x, next_y)
    when 2
      if @test_input
        next_x, next_y, next_f = wrap_around_part2_test(x, y, next_x, next_y, next_f)
      else
        next_x, next_y, next_f = wrap_around_part2(x, y, next_x, next_y, next_f)
      end
    end
    break unless @board[next_y][next_x] == '.'

    x, y, f = [next_x, next_y, next_f]
  end
  pos.merge!(x: x, y: y, f: f)
end

def turn(pos, clockwise)
  inc_f = clockwise ? 1 : -1
  pos[:f] = (pos[:f] + inc_f) % 4
end

def simulate(part)
  current_pos = { x: @board[0].index('.'), y: 0, f: FACING_RIGHT }
  steps = 0
  @path.chars.each do |c|
    case c
    when 'R'
      move(current_pos, steps, part)
      turn(current_pos, true)
      steps = 0
    when 'L'
      move(current_pos, steps, part)
      turn(current_pos, false)
      steps = 0
    else
      steps = 10 * steps + c.ord - '0'.ord
    end
  end
  move(current_pos, steps, part)

  puts "Part #{part}: #{1000 * (current_pos[:y] + 1) + 4 * (current_pos[:x] + 1) + current_pos[:f]}"
end

simulate(1)
simulate(2)

puts "Exec time: #{Time.now - start_time}"

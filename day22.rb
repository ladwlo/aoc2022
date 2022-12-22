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
@col_ranges = Array.new(w) { [h, 0] }

(1..h).each do |r|
  row = input[r - 1]
  @board.append(row)
  xmin = row.index(/\.|#/) + 1
  xmax = row.rstrip.length
  @row_ranges.append([xmin, xmax])
  (xmin..xmax).each do |x|
    col_range = @col_ranges[x - 1]
    col_range[0] = [col_range[0], r].min
    col_range[1] = [col_range[1], r].max
  end
end

@path = input.last

def wrap_around_part1(x, y, next_x, next_y)
  row_range = @row_ranges[y - 1]
  col_range = @col_ranges[x - 1]
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

def wrap_around_part2_test(x, y, next_x, next_y, next_f)
  c = x - 1
  r = y - 1
  col_range = @col_ranges[c]
  row_range = @row_ranges[r]
  cube_dim = @row_ranges.length / 3
  if next_x < row_range[0]
    case r / cube_dim
    when 0
      next_x, next_y, next_f = [cube_dim + y, cube_dim + 1, FACING_DOWN]
    when 1
      next_x, next_y, next_f = [5 * cube_dim - y + 1, 3 * cube_dim, FACING_UP]
    when 2
      next_x, next_y, next_f = [4 * cube_dim - y + 1, 2 * cube_dim, FACING_UP]
    end
  elsif next_x > row_range[1]
    case r / cube_dim
    when 0
      next_x, next_y, next_f = [4 * cube_dim, 3 * cube_dim - y + 1, FACING_LEFT]
    when 1
      next_x, next_y, next_f = [5 * cube_dim - y + 1, 2 * cube_dim + 1, FACING_DOWN]
    when 2
      next_x, next_y, next_f = [3 * cube_dim, 3 * cube_dim - y + 1, FACING_LEFT]
    end
  elsif next_y < col_range[0]
    case c / cube_dim
    when 0
      next_x, next_y, next_f = [3 * cube_dim - x + 1, 1, FACING_DOWN]
    when 1
      next_x, next_y, next_f = [2 * cube_dim + 1, x - cube_dim, FACING_RIGHT]
    when 2
      next_x, next_y, next_f = [3 * cube_dim - x + 1, cube_dim + 1, FACING_LEFT]
    when 3
      next_x, next_y, next_f = [3 * cube_dim, 5 * cube_dim - x + 1, FACING_LEFT]
    end
  elsif next_y > col_range[1]
    case c / cube_dim
    when 0
      next_x, next_y, next_f = [3 * cube_dim - x + 1, 3 * cube_dim, FACING_UP]
    when 1
      next_x, next_y, next_f = [2 * cube_dim + 1, 4 * cube_dim - x + 1, FACING_RIGHT]
    when 2
      next_x, next_y, next_f = [3 * cube_dim - x + 1, 2 * cube_dim, FACING_UP]
    when 3
      next_x, next_y, next_f = [1, 5 * cube_dim - x + 1, FACING_RIGHT]
    end
  end
  [next_x, next_y, next_f]
end

def wrap_around_part2(x, y, next_x, next_y, next_f)
  c = x - 1
  r = y - 1
  col_range = @col_ranges[c]
  row_range = @row_ranges[r]
  cube_dim = @row_ranges.length / 4
  if next_x < row_range[0]
    case r / cube_dim
    when 0
      next_x, next_y, next_f = [1, 3 * cube_dim - y + 1, FACING_RIGHT]
    when 1
      next_x, next_y, next_f = [y - cube_dim, 2 * cube_dim + 1, FACING_DOWN]
    when 2
      next_x, next_y, next_f = [cube_dim + 1, 3 * cube_dim - y + 1, FACING_RIGHT]
    when 3
      next_x, next_y, next_f = [y - 2 * cube_dim, 1, FACING_DOWN]
    end
  elsif next_x > row_range[1]
    case r / cube_dim
    when 0
      next_x, next_y, next_f = [2 * cube_dim, 3 * cube_dim - y + 1, FACING_LEFT]
    when 1
      next_x, next_y, next_f = [cube_dim + y, cube_dim, FACING_UP]
    when 2
      next_x, next_y, next_f = [3 * cube_dim, 3 * cube_dim - y + 1, FACING_LEFT]
    when 3
      next_x, next_y, next_f = [y - 2 * cube_dim, 3 * cube_dim, FACING_UP]
    end
  elsif next_y < col_range[0]
    case c / cube_dim
    when 0
      next_x, next_y, next_f = [cube_dim + 1, cube_dim + x, FACING_RIGHT]
    when 1
      next_x, next_y, next_f = [1, 2 * cube_dim + x, FACING_RIGHT]
    when 2
      next_x, next_y, next_f = [x - 2 * cube_dim, 4 * cube_dim, FACING_UP]
    end
  elsif next_y > col_range[1]
    case c / cube_dim
    when 0
      next_x, next_y, next_f = [x + 2 * cube_dim, 1, FACING_DOWN]
    when 1
      next_x, next_y, next_f = [cube_dim, x + 2 * cube_dim, FACING_LEFT]
    when 2
      next_x, next_y, next_f = [2 * cube_dim, x - cube_dim, FACING_LEFT]
    end
  end
  [next_x, next_y, next_f]
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
    break unless @board[next_y - 1][next_x - 1] == '.'

    x, y, f = [next_x, next_y, next_f]
  end
  pos.merge!(x: x, y: y, f: f)
end

def turn(pos, clockwise)
  inc_f = clockwise ? 1 : -1
  pos[:f] = (pos[:f] + inc_f) % 4
end

def simulate(part)
  current_pos = { x: @board[0].index('.') + 1, y: 1, f: FACING_RIGHT }
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

  puts "Part #{part}: #{1000 * current_pos[:y] + 4 * current_pos[:x] + current_pos[:f]}"
end

simulate(1)
simulate(2)

puts "Exec time: #{Time.now - start_time}"

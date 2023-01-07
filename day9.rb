require 'set'

input = 'input/day9.txt'

f = open(input, 'r')
lines = f.readlines.map(&:strip)
f.close

hx = hy = tx = ty = 0
visited = Set.new([[tx, ty]])
lines.each do |line|
  moves = line.split(' ')
  dir = moves.first
  step = moves.last.to_i
  (1..step).each do
    case dir
    when 'L'
      hx -= 1
      if hx < tx - 1
        tx = hx + 1
        ty = hy
      end
    when 'R'
      hx += 1
      if hx > tx + 1
        tx = hx - 1
        ty = hy
      end
    when 'U'
      hy += 1
      if hy > ty + 1
        tx = hx
        ty = hy - 1
      end
    when 'D'
      hy -= 1
      if hy < ty - 1
        tx = hx
        ty = hy + 1
      end
    end
    visited.add([tx, ty])
  end
end

puts visited.length

# part 2

def follow(snake, n)
  # makes segment at position n > 0 follow its predecessor
  px = snake[n - 1].first
  py = snake[n - 1].last
  sx = snake[n].first
  sy = snake[n].last
  if sx == px
    sy += 1 if py - sy == 2
    sy -= 1 if py - sy == -2
  elsif sy == py
    sx += 1 if px - sx == 2
    sx -= 1 if px - sx == -2
  elsif (px - sx).abs == 2 || (py - sy).abs == 2 # diagonal move towards px,py
    sx += (px - sx <=> 0)
    sy += (py - sy <=> 0)
  end
  snake[n] = [sx, sy]
end

def print_map(snake)
  map = Array.new(40) { Array.new(40) { '.' } }
  snake.each_with_index do |seg, n|
    map[25 - seg.last][15 + seg.first] = n.to_s
  end
  map.each { |row| puts row.join }
end

snake = Array.new(10) { [0, 0] }
visited = Set.new([[0, 0]])
lines.each do |line|
  moves = line.split(' ')
  dir = moves.first
  step = moves.last.to_i
  (1..step).each do
    nx = snake[0].first
    ny = snake[0].last
    case dir
    when 'L'
      nx -= 1
    when 'R'
      nx += 1
    when 'U'
      ny += 1
    when 'D'
      ny -= 1
    end
    snake[0] = [nx, ny]
    (1..snake.length - 1).each { |n| follow(snake, n) }
    visited.add([snake.last.first, snake.last.last])
    # print_map(snake)
  end
end

puts visited.length

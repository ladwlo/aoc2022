require "rubygems"
require "rmagick"

include Magick

def render(gif, board, dx, dy)
  return unless gif

  pixels = Array.new(dx * dy * 3) { 0.0 }
  board.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      r = g = b = 0
      case cell
      when '.'
        r = 0.75
        g = 0.75
        b = 1.0
      when '#'
        r = 1.0
        g = 0.0
        b = 0.0
      when 'o'
        r = 1.0
        g = 1.0
        b = 0.0
      end
      pixels[3 * (y * dx + x)] = r
      pixels[3 * (y * dx + x) + 1] = g
      pixels[3 * (y * dx + x) + 2] = b
    end
  end
  gif << Magick::Image.constitute(dx, dy, 'RGB', pixels)
end

input = 'input/day14.txt'

f = File.open(input)
paths = f.readlines.map(&:rstrip).map { |s| s.split(' -> ').map { |s| s.split(',').map(&:to_i) } }
f.close

minx = maxx = paths.first.first.first
miny = 0
maxy = paths.first.first.last
paths.each do |path|
  path.each do |cell|
    minx = cell.first if cell.first < minx
    maxx = cell.first if cell.first > maxx
    maxy = cell.last if cell.last > maxy
  end
end
maxy += 2
dy = maxy - miny + 1

minx = [minx, 500 - dy].min
maxx = [maxx, 500 + dy].max

dx = maxx - minx + 1

def make_range(v1, v2)
  ([v1, v2].min..[v1, v2].max)
end

board = Array.new(dy) { Array.new(dx) { '.' } }
paths.each do |path|
  prev_cell = nil
  path.each do |cell|
    if prev_cell
      if prev_cell.first == cell.first # vertical
        x = cell.first
        make_range(prev_cell.last, cell.last).each { |y| board[y - miny][x - minx] = '#' }
      else # horizontal
        y = cell.last
        make_range(prev_cell.first, cell.first).each { |x| board[y - miny][x - minx] = '#' }
      end
    end
    prev_cell = cell
  end
end

(0..(dx - 1)).each { |x| board[dy - 1][x] = '#' } # part 2 -> floor

generate_animation = false
gif = ImageList.new if generate_animation

count = 0
frame = 0
found1 = false
while true
  x = 500 - minx
  y = 0
  break unless board[y][x] == '.'

  while true
    frame += 1
    new_y = y + 1
    new_x = [x, x - 1, x + 1].select { |nx| nx < 0 || nx >= dx || board[new_y][nx] == '.' }.first
    if new_x
      if new_x < 0 || new_x >= dx || new_y == dy - 1
        unless found1
          puts "Part 1: #{count}"
          found1 = true
        end
        break
      end
      x = new_x
      y = new_y
      if frame % 1000 == 0
        board[y][x] = 'o'
        render(gif, board, dx, dy)
        board[y][x] = '.'
      end
    else
      board[y][x] = 'o'
      render(gif, board, dx, dy) if frame % 1000 == 0
      break
    end
  end

  count += 1
end

puts "Part2: #{count}"

# board.each { |row| puts row.join }

gif&.write("aoc2022-day14.gif")

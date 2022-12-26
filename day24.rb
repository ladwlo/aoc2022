require 'set'

start_time = Time.now

test_run = false
@input = File.readlines("input/day24#{test_run ? '_test' : ''}.txt", chomp: true)

blizzards = []
@input.each_with_index do |line, y|
  line.chars.each_with_index do |c, x|
    blizzards.append([x, y, c]) if '>^<v'.include?(c)
  end
end

MOVES = [[0, -1], [-1, 0], [0, 0], [1, 0], [0, 1]]

def shortest_travel_time(start_loc, end_loc, blizzards, w, h)
  step = 0
  next_set = Set.new([start_loc])
  loop do
    step += 1
    locations_to_inspect = next_set
    next_set = Set.new
    blizzard_presence = Array.new(h) { Array.new(w) { '.' } }
    # move blizzards to their new locations
    blizzards.each do |blizzard|
      x, y, d = blizzard
      case d
      when '<' then x = (x - 2) % (w - 2) + 1
      when '^' then y = (y - 2) % (h - 2) + 1
      when '>' then x = x % (w - 2) + 1
      when 'v' then y = y % (h - 2) + 1
      end
      blizzard[0] = x
      blizzard[1] = y
      blizzards_at_x_y = blizzard_presence[y][x]
      blizzard_presence[y][x] = case blizzards_at_x_y
                                when '.' then d
                                when String then 2
                                else blizzards_at_x_y + 1
                                end
    end
    # explore locations accessible in the Nth step
    locations_to_inspect.each do |x, y|
      MOVES.each do |dx, dy|
        new_x, new_y = new_loc = [x + dx, y + dy]
        next if new_x < 0 || new_x == w || new_y < 0 || new_y == h || blizzard_presence[new_y][new_x] != '.' || @input[new_y][new_x] == '#'

        return step if new_loc == end_loc

        next_set.add(new_loc)
        blizzard_presence[new_y][new_x] = '*'
      end
    end
  end
end

w = @input[0].length
h = @input.length

start_loc = [1, 0]
end_loc = [w - 2, h - 1]

t1 = shortest_travel_time(start_loc, end_loc, blizzards, w, h)
puts("Part 1: #{t1}")

t2 = shortest_travel_time(end_loc, start_loc, blizzards, w, h)
t3 = shortest_travel_time(start_loc, end_loc, blizzards, w, h)
puts("Part 2: #{t1 + t2 + t3}")

puts("Exec time: #{Time.now - start_time}")

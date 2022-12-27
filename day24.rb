start_time = Time.now

test_run = false
@input = File.readlines("input/day24#{test_run ? '_test' : ''}.txt", chomp: true)

blizzards = []
@input.each_with_index do |line, y|
  line.chars.each_with_index do |c, x|
    case c
    when '<' then blizzards.append([x, y, -1, 0])
    when '^' then blizzards.append([x, y, 0, -1])
    when '>' then blizzards.append([x, y, 1, 0])
    when 'v' then blizzards.append([x, y, 0, 1])
    end
  end
end

MOVES = [[0, -1], [-1, 0], [0, 0], [1, 0], [0, 1]].freeze

def travel_from_to(start_loc, end_loc, blizzards, w, h, step)
  queued_locations = [start_loc]
  visited = Array.new(h) { Array.new(w) }
  blizzard_presence = Array.new(h) { Array.new(w) }
  loop do
    step += 1
    locations_to_inspect = queued_locations
    queued_locations = []
    # calculate the number of blizzards present at each location x,y
    blizzard_presence.each { |row| row.fill(0) }
    blizzards.each do |x0, y0, dx, dy|
      bx = (x0 + dx * step - 1) % (w - 2) + 1
      by = (y0 + dy * step - 1) % (h - 2) + 1
      blizzard_presence[by][bx] += 1
    end
    # explore locations accessible in the Nth step
    visited.each { |row| row.fill(false) }
    locations_to_inspect.each do |x, y|
      MOVES.each do |dx, dy|
        new_x, new_y = new_loc = [x + dx, y + dy]
        next if new_x < 0 || new_x == w || new_y < 0 || new_y == h ||
                blizzard_presence[new_y][new_x] > 0 ||
                visited[new_y][new_x] ||
                @input[new_y][new_x] == '#'

        return step if new_loc == end_loc

        visited[new_y][new_x] = true
        queued_locations << new_loc
      end
    end
  end
end

w = @input[0].length
h = @input.length

start_loc = [1, 0]
end_loc = [w - 2, h - 1]

steps = travel_from_to(start_loc, end_loc, blizzards, w, h, 0)
puts("Part 1: #{steps}")

steps = travel_from_to(end_loc, start_loc, blizzards, w, h, steps)
steps = travel_from_to(start_loc, end_loc, blizzards, w, h, steps)
puts("Part 2: #{steps}")

puts("Exec time: #{Time.now - start_time}")

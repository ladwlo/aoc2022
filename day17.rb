wind = File.readlines('input/day17.txt').first.rstrip

ROCKS = [
  %w[####],
  %w[.#. ### .#.],
  %w[..# ..# ###],
  %w[# # # #],
  %w[## ##]
].freeze

BOARD_WIDTH = 7

def can_move?(rock, board, x, y, shift_x, shift_y)
  if shift_y.zero?
    return false if shift_x.negative? ? x.zero? : x + rock.first.length == BOARD_WIDTH
  else
    return false if y < rock.length
  end

  rock.each_with_index do |row, yr|
    # xb, yb - location of the rock's top-left corner in the board's coordinate frame
    yb = y - yr
    row.chars.each_with_index do |c, xr|
      xb = x + xr
      return false if c == '#' && board[yb + shift_y][xb + shift_x] != '.'
    end
  end

  true
end

def merge_rock(rock, board, x, y)
  rock.each_with_index do |row, yr|
    # xb, yb - location of the rock's top-left corner in the board's coordinate frame
    yb = y - yr
    row.chars.each_with_index do |c, xr|
      xb = x + xr
      board[yb][xb] = '#' if c == '#'
    end
  end
end

board = []

history = {}
height_history = {}
height_profile = [0] * BOARD_WIDTH

part_1_done = false
part_2_done = false
wind_index = 0
current_height = 0
current_round = 1
until part_1_done && part_2_done
  rock = ROCKS[(current_round - 1) % ROCKS.length]
  min_height = current_height + rock.length + 3
  (min_height - board.length).times { board << '.......' }
  x = 2
  y = min_height - 1
  loop do
    # simulate wind
    shift = wind[wind_index] == '>' ? 1 : -1
    wind_index += 1
    wind_index = 0 if wind_index == wind.length
    x += shift if can_move?(rock, board, x, y, shift, 0)
    # simulate downfall
    if can_move?(rock, board, x, y, 0, -1)
      y -= 1
    else
      merge_rock(rock, board, x, y)
      # update height profile
      rock.each_with_index do |row, yr|
        row.chars.each_with_index do |c, xr|
          height_profile[x + xr] = [height_profile[x + xr], y - yr + 1].max if c == '#'
        end
      end
      break
    end
  end
  current_height = [current_height, y + 1].max
  height_history[current_round] = current_height
  if current_round == 2022
    puts "Part 1: #{current_height}"
    part_1_done = true
  end
  if (current_round % ROCKS.length).zero?
    normalized_profile = height_profile.map { |y| y - height_profile.min }
    past_data = history[wind_index]
    if !part_2_done && past_data && past_data[:profile] == normalized_profile
      first_round_of_cycle = past_data[:round]
      rounds_per_cycle = current_round - first_round_of_cycle
      height_increase_per_cycle = current_height - past_data[:height]
      remaining_rounds = 1_000_000_000_000 - first_round_of_cycle
      remaining_cycles = remaining_rounds / rounds_per_cycle
      reference_round = first_round_of_cycle + remaining_rounds % rounds_per_cycle
      puts "Part 2: #{height_history[reference_round] + remaining_cycles * height_increase_per_cycle}"
      part_2_done = true
    end
    history[wind_index] = { round: current_round, height: current_height, profile: normalized_profile }
  end
  current_round += 1
end

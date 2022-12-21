start_time = Time.now

input = File.open('input/day20.txt').readlines.map(&:rstrip).map(&:to_i)

# === common stuff ===

def range(numbers)
  0..(numbers.length - 1)
end

def shuffle(numbers, indices)
  range(numbers).each do |original_index|
    shuffled_index = indices.index(original_index)
    number = numbers[shuffled_index]
    new_index = (shuffled_index + number) % (numbers.length - 1)
    indices.delete_at(shuffled_index)
    indices.insert(new_index, original_index)
    numbers.delete_at(shuffled_index)
    numbers.insert(new_index, number)
  end
end

def final_sum(numbers)
  zero_index = numbers.index(0)
  [1000, 2000, 3000].map { |offset| numbers[(zero_index + offset) % numbers.length] }.reduce(&:+)
end

# === part 1 ===

numbers = Array.new(input)
indices = range(numbers).map(&:itself)

shuffle(numbers, indices)

puts "Part 1: #{final_sum(numbers)}"

# === part 1 ===

numbers = input.map { |x| x * 811_589_153 }
indices = range(numbers).map(&:itself)

10.times { shuffle(numbers, indices) }

puts "Part 2: #{final_sum(numbers)}"

puts "Exec time: #{Time.now - start_time}"

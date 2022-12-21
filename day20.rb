numbers = File.open('input/day20_test.txt').readlines.map(&:rstrip).map(&:to_i)
n = numbers.length

indices = (0..(n - 1)).map(&:itself)

(0..(n - 1)).each do |original_index|
  shuffled_index = indices.index(original_index)
  number = numbers[shuffled_index]
  # puts "Picking #{number} at #{shuffled_index}"
  new_index = (shuffled_index + number) % (n - 1)
  indices.delete_at(shuffled_index)
  indices.insert(new_index, original_index)
  numbers.delete_at(shuffled_index)
  numbers.insert(new_index, number)
  # puts numbers.inspect
end

zero_index = numbers.index(0)

sum = [1000, 2000, 3000].map { |offset| numbers[(zero_index + offset) % n] }.reduce(&:+)

puts "Part 1: #{sum}"


numbers = File.open('input/day20.txt').readlines.map(&:rstrip).map(&:to_i).map { |x| x * 811589153 }
n = numbers.length

indices = (0..(n - 1)).map(&:itself)
10.times do
  (0..(n - 1)).each do |original_index|
    shuffled_index = indices.index(original_index)
    number = numbers[shuffled_index]
    new_index = (shuffled_index + number) % (n - 1)
    indices.delete_at(shuffled_index)
    indices.insert(new_index, original_index)
    numbers.delete_at(shuffled_index)
    numbers.insert(new_index, number)
  end
end

zero_index = numbers.index(0)

sum = [1000, 2000, 3000].map { |offset| numbers[(zero_index + offset) % n] }.reduce(&:+)

puts "Part 2: #{sum}"

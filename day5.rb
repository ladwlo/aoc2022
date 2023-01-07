input = 'input/day5.txt'

stacks = []
f = open(input, 'r')
f.readlines.each do |line|
  line.rstrip!
  next if line.empty?

  if line.start_with?('move')
    count, from, to = line.split.slice((1..5).step(2)).map(&:to_i)
    (1..count).each { |_| stacks[to - 1].push(stacks[from - 1].pop) }
  else
    n = (line.length + 1) / 4
    stacks << [] while n > stacks.length
    (0..(n - 1)).each do |i|
      c = line[4 * i + 1]
      next if c == ' '

      stacks[i].insert(0, c)
    end
  end
end
f.close

puts (1..stacks.length).map { |i| stacks[i - 1].pop }.join('')

stacks = []
f = open(input, 'r')
f.readlines.each do |line|
  line.rstrip!
  next if line.empty?

  if line.start_with?('move')
    count, from, to = line.split.slice((1..5).step(2)).map(&:to_i)
    stacks[to - 1].push(*stacks[from - 1].pop(count))
  else
    n = (line.length + 1) / 4
    stacks << [] while n > stacks.length
    (0..(n - 1)).each do |i|
      c = line[4 * i + 1]
      next if c == ' '

      stacks[i].insert(0, c)
    end
  end
end
f.close

puts (1..stacks.length).map { |i| stacks[i - 1].pop }.join('')

input = 'input/day4.txt'

count = 0
f = open(input)
f.readlines.each do |line|
  pair1, pair2 = line.strip.split(',')
  from1, to1 = pair1.split('-').map(&:to_i)
  from2, to2 = pair2.split('-').map(&:to_i)
  count += 1 if (from2 >= from1 && to2 <= to1) || (from1 >= from2 && to1 <= to2)
end
f.close

puts count

count = 0
f = open(input)
f.readlines.each do |line|
  pair1, pair2 = line.strip.split(',')
  from1, to1 = pair1.split('-').map(&:to_i)
  from2, to2 = pair2.split('-').map(&:to_i)
  count += 1 if from2 <= to1 && to2 >= from1
end
f.close

puts count

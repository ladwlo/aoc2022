f = open('input/day1.txt', 'r')
sum = max_sum = 0
f.readlines.each do |line|
  line.strip!
  if line == ''
    max_sum = sum if sum > max_sum
    sum = 0
    next line
  end
  sum += line.to_i
end
f.close
max_sum = sum if sum > max_sum
puts max_sum

f = open('input/day1.txt', 'r')
sum = 0
max_sums = []
f.readlines.each do |line|
  line.strip!
  if line == ''
    max_sums << sum
    max_sums = max_sums.max(3)
    sum = 0
    next line
  end
  sum += line.to_i
end
f.close
max_sums << sum
max_sums = max_sums.max(3)
puts max_sums.sum
require 'set'

f = open('input/day3.txt', 'r')
sum = 0
f.readlines.each do |line|
  line.strip!
  n = line.length / 2
  set1 = Set.new(line[0..(n - 1)].chars)
  set2 = Set.new(line[n..].chars)
  c = (set1 & set2).first
  case c
  when 'A'..'Z'
    sum += c.ord - 'A'.ord + 27
  when 'a'..'z'
    sum += c.ord - 'a'.ord + 1
  end
end
f.close
puts sum

f = open('input/day3.txt', 'r')
sum = 0
n = 0
common_set = nil
f.readlines.each do |line|
  line.strip!
  chars = line.chars
  n += 1
  common_set = if n == 1
                 Set.new(chars)
               else
                 common_set & chars
               end
  next n if n < 3

  c = common_set.first
  case c
  when 'A'..'Z'
    sum += c.ord - 'A'.ord + 27
  when 'a'..'z'
    sum += c.ord - 'a'.ord + 1
  end
  n = 0
end
f.close
puts sum
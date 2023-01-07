require 'set'

input = 'input/day6.txt'

f = open(input, 'r')
f.readlines.each do |line|
  line.rstrip!
  chars = line.chars
  (13..(chars.length - 1)).each do |ptr|
    if Set.new(chars[(ptr - 13)..ptr]).length == 14
      puts (ptr + 1)
      break
    end
  end
end

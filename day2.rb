score = 0
f = open('input/day2.txt', 'r')
f.readlines.each do |line|
  moves = line.strip.split(' ')
  m1 = moves.first.ord - 'A'.ord
  m2 = moves.last.ord - 'X'.ord
  case (m2 - m1) % 3
  when 0
    score += 3
  when 1
    score += 6
  end
  score += m2 + 1
end
puts score

score = 0
f = open('input/day2.txt', 'r')
f.readlines.each do |line|
  input = line.strip.split(' ')
  m1 = input.first.ord - 'A'.ord
  case input.last
  when 'X' # lose
    score += (m1 - 1) % 3 + 1
  when 'Y' # draw
    score += m1 + 4
  when 'Z' # win
    score += (m1 + 1) % 3 + 7
  end
end
puts score

input = 'input/day8.txt'

f = open(input, 'r')
trees = f.readlines.map(&:strip).map(&:chars).map { |chars| chars.map(&:to_i) }
f.close

rows = trees.length
cols = trees[0].length

count = 0

(0..(rows - 1)).each do |row|
  (0..(cols - 1)).each do |col|
    h = trees[row][col]
    visible_w = col.zero? || (0..(col - 1)).all? { |c| trees[row][c] < h }
    visible_e = col == cols - 1 || ((col + 1)..(cols - 1)).all? { |c| trees[row][c] < h }
    visible_n = row.zero? || (0..(row - 1)).all? { |r| trees[r][col] < h }
    visible_s = row == rows - 1 || ((row + 1)..(rows - 1)).all? { |r| trees[r][col] < h }
    count += 1 if visible_w || visible_e || visible_n || visible_s
  end
end

puts count

max_score = 0

(0..(rows - 1)).each do |row|
  (0..(cols - 1)).each do |col|
    h = trees[row][col]
    w = 0
    ((col - 1)..0).step(-1).each do |c|
      w += 1
      break if trees[row][c] >= h
    end
    e = 0
    ((col + 1)..(cols - 1)).each do |c|
      e += 1
      break if trees[row][c] >= h
    end
    n = 0
    ((row - 1)..0).step(-1).each do |r|
      n += 1
      break if trees[r][col] >= h
    end
    s = 0
    ((row + 1)..(rows - 1)).each do |r|
      s += 1
      break if trees[r][col] >= h
    end
    score = w * e * n * s
    max_score = score if score > max_score
  end
end

puts max_score

input = 'input/day13.txt'

def cmp(l1, l2)
  n = [l1, l2].map(&:length).min
  (0..(n - 1)).each do |i|
    e1 = l1[i]
    e2 = l2[i]
    if e1.is_a?(Integer) && e2.is_a?(Integer)
      c = e1 <=> e2
    else
      e1 = [e1] unless e1.is_a? Array
      e2 = [e2] unless e2.is_a? Array
      c = cmp(e1, e2)
    end
    return c unless c.zero?
  end
  l1.length <=> l2.length
end

f = File.open(input)
lists = f.readlines.map(&:rstrip).reject(&:empty?).map { |s| eval(s) }
f.close

puts (1..(lists.length / 2)).select { |i| cmp(lists[2 * i - 2], lists[2 * i - 1]) <= 0 }.reduce(&:+)

markers = [[[2]], [[6]]]
sorted = [*lists, *markers].sort { |l1, l2| cmp(l1, l2) }
puts markers.map { |m| sorted.index(m) + 1 }.reduce(&:*)

# def parse(line)
#   stack = []
#   list = nil
#   chars = []
#   line.chars.each do |c|
#     case c
#     when '['
#       stack << list unless list.nil?
#       list = []
#     when ']', ','
#       unless chars.empty?
#         list << chars.join.to_i
#         chars = []
#       end
#       if c == ']'
#         return list if stack.empty?
#
#         parent_list = stack.pop
#         parent_list << list
#         list = parent_list
#       end
#     else
#       chars << c
#     end
#   end
# end

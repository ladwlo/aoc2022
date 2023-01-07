input = 'input/day7.txt'

f = open(input, 'r')
lines = f.readlines.map(&:strip)
f.close

# rubocop:disable Metrics/BlockNesting

root = { '/' => {} }
current_dir = root

n = lines.length
i = 0
while i < n
  line = lines[i].split(' ')
  i += 1
  cmd = line[1]
  case cmd
  when 'cd'
    target = line[2]
    current_dir = target == '/' ? root : current_dir[target]
  when 'ls'
    while i < n && !lines[i].start_with?('$')
      line = lines[i].split(' ')
      i += 1
      if line[0] == 'dir'
        target = line[1]
        current_dir[target] = { '..' => current_dir } unless current_dir.key?(target)
      else
        size = line[0].to_i
        name = line[1]
        current_dir[name] = size
      end
    end
  end
end

@total = 0
@smallest_to_free = 0
@space_needed = 0

def dir_size(dir)
  size = dir.except('..').values.reduce(0) { |a, b| a + (b.is_a?(Hash) ? dir_size(b) : b) }
  @total += size if size <= 100_000
  @smallest_to_free = size if size >= @space_needed && (size < @smallest_to_free || @smallest_to_free < 0)
  size
end

root_size = dir_size(root)

puts @total

@unused_space = 70_000_000 - root_size
@space_needed = 30_000_000 - @unused_space
@smallest_to_free = -1

dir_size(root)

puts @smallest_to_free

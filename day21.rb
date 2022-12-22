test_run = false

start_time = Time.now

input = File.readlines("input/day21#{test_run ? '_test' : ''}.txt", chomp: true)
            .map { |line| line.split(/:? /) }

class Monkey
  attr_accessor :id, :parent, :left, :right, :operator, :number

  def initialize(id, parent)
    @id = id
    @parent = parent
  end

  def yell
    return number if number

    x = left.yell
    y = right.yell
    @number = case operator
              when '+'
                x + y
              when '-'
                x - y
              when '*'
                x * y
              when '/'
                x / y
              end
  end
end

@monkeys = {}

def get_monkey(id, parent = nil)
  @monkeys[id] ||= Monkey.new(id, parent)
  @monkeys[id].tap { |monkey| monkey.parent = parent if parent }
end

input.each do |fields|
  monkey = get_monkey(fields[0])
  if fields.length == 2
    monkey.number = fields[1].to_i
  else
    monkey.left = get_monkey(fields[1], monkey)
    monkey.operator = fields[2]
    monkey.right = get_monkey(fields[3], monkey)
  end
end

puts "Part 1: #{@monkeys['root'].yell}"

# set numbers of all parents of 'humn' to unknown
monkey = @monkeys['humn']
while monkey.parent
  monkey.number = nil
  monkey = monkey.parent
end

# now, monkey == root
# copy the known child's number to the unknown one
known, unknown = monkey.left.number ? [monkey.left, monkey.right] : [monkey.right, monkey.left]
unknown.number = known.number

# now, traverse the unknown branch of the tree, reversing the operations
monkey = unknown
until monkey.id == 'humn'
  known, unknown = monkey.left.number ? [monkey.left, monkey.right] : [monkey.right, monkey.left]
  unknown.number = case monkey.operator
                   when '+'
                     monkey.number - known.number
                   when '-'
                     unknown == monkey.left ? known.number + monkey.number : known.number - monkey.number
                   when '*'
                     monkey.number / known.number
                   when '/'
                     unknown == monkey.left ? known.number * monkey.number : known.number / monkey.number
                   end
  monkey = unknown
end

puts "Part 2: #{monkey.number}"
puts "Exec time: #{Time.now - start_time}"

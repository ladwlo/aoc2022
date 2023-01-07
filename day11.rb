# frozen_string_literal: true

DIVISORS = [0, 2, 3, 5, 7, 11, 13, 17, 19, 23].freeze

class Item

  attr_accessor :worry_level

  def initialize(worry_level)
    @worry_level = DIVISORS.each_with_object({}) { |divisor, hash| hash[divisor] = worry_level }
  end

  def next_monkey(monkey)
    DIVISORS[1..].each do |divisor|
      value = worry_level[divisor]
      operand = monkey.operand || value
      case monkey.operator
      when '+'
        value += operand
      when '*'
        value *= operand
      end
      value = value % divisor
      worry_level[divisor] = value
    end
    monkey.target[worry_level[monkey.divisor].zero?]
  end
end

class Monkey

  attr_accessor :items, :inspections
  attr_reader :operator, :operand, :divisor, :target

  def initialize(lines)
    @items = lines[1].split(/,? /)[2..].map(&:to_i).map { |n| Item.new(n) }
    @operator = lines[2].split(' ')[4]
    @operand = lines[2].split(' ')[5].then { |val| val == 'old' ? nil : val.to_i }
    @divisor = lines[3].split(' ')[3].to_i
    @target = { true => lines[4].split(' ')[5].to_i, false => lines[5].split(' ')[5].to_i }
    @inspections = 0
  end
end

input = 'input/day11.txt'

f = File.open(input, 'r')
lines = f.readlines.map(&:strip)
f.close

# == part 1 ==

monkey_count = (lines.length + 1) / 7
monkeys = (0..(monkey_count - 1)).map { |n| Monkey.new(lines[7 * n, 6]) }

rounds = 20
(1..rounds).each do |round|
  # puts("== round #{round} ==")
  monkeys.each do |monkey|
    monkey.inspections += monkey.items.count
    monkey.items.each do |item|
      worry_level = item.worry_level[0]
      operand = monkey.operand || worry_level
      case monkey.operator
      when '+'
        worry_level += operand
      when '*'
        worry_level *= operand
      end
      worry_level /= 3
      target_monkey = monkeys[monkey.target[(worry_level % monkey.divisor).zero?]]
      target_monkey.items << item
      item.worry_level[0] = worry_level
    end
    monkey.items = []
  end
  #  monkeys.each { |m| puts m.items.join(',') }
end
puts monkeys.map(&:inspections).sort.last(2).reduce(:*)

# == part 2 ==

monkeys = (0..(monkey_count - 1)).map { |n| Monkey.new(lines[7 * n, 6]) }

rounds = 10_000
(1..rounds).each do |round|
  # puts("== round #{round} ==")
  monkeys.each do |monkey|
    monkey.inspections += monkey.items.count
    monkey.items.each do |item|
      target_monkey = monkeys[item.next_monkey(monkey)]
      target_monkey.items << item
    end
    monkey.items = []
  end
  # puts "Round #{round}: #{monkeys.map(&:inspections).map(&:to_s).join(',')}"
end
puts monkeys.map(&:inspections).sort.last(2).reduce(:*)

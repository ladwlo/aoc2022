start_time = Time.now

test_run = false
input = File.readlines("input/day25#{test_run ? '_test' : ''}.txt", chomp: true)

TOKENS = '=-012'.freeze

def snafu_to_dec(s)
  power_of_five = 1
  value = 0
  s.chars.reverse.each do |c|
    value += (TOKENS.index(c) - 2) * power_of_five
    power_of_five *= 5
  end
  value
end

def dec_to_snafu(n)
  chars = []
  until n.zero?
    x = n % 5
    if x > 2
      chars << TOKENS[x - 3]
      carry = 1
    else
      chars << TOKENS[x + 2]
      carry = 0
    end
    n = n / 5 + carry
  end
  chars.reverse.join
end

puts "Part 1: #{dec_to_snafu(input.map { |s| snafu_to_dec(s) }.reduce(&:+))}"

puts "Exec time: #{Time.now - start_time}"

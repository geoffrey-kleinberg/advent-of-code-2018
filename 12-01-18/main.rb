require 'set'

day = "01"
file_name = "12-#{day}-18/sampleIn.txt"
file_name = "12-#{day}-18/input.txt"

data = File.read(file_name).split("\n").map { |i| i.strip }

def part1(input)
    return input.map { |i| (i[0] == "-") ? (-1 * i[1..].to_i ) : (i[1..].to_i) }.sum
end

def part2(input)
    frequencies = Set[]
    nums = input.map { |i| (i[0] == "-") ? (-1 * i[1..].to_i ) : (i[1..].to_i) }
    sum = 0
    while true
      for i in 0...nums.length
        if not frequencies.add? sum
            return sum
        end
        sum += nums[i]
      end
    end
    return nil
end

puts part1(data)
puts part2(data)
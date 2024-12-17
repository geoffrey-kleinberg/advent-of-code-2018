require 'set'

day = "05"
file_name = "12-#{day}-18/sampleIn.txt"
file_name = "12-#{day}-18/input.txt"

data = File.read(file_name).split("\n").map { |i| i.strip }

def part1(input)
    input = input[0]
    i = 0
    while i < input.length - 1
      char = input[i]
      nextChar = input[i + 1]
      if char == nextChar
        i += 1
        next
      end
      if char.upcase == nextChar or char.downcase == nextChar
        input = input[0...i] + input[(i + 2)..]
        if i != 0
          i -= 2
        else
          i -= 1
        end
      end
      i += 1
      # puts i
    end
    return input.length
end

def part2(input)
  original = input[0]
  best = Float::INFINITY
  for letter in 'a'..'z'
    input = original.delete(letter + letter.upcase)
    i = 0
    while i < input.length - 1
      char = input[i]
      nextChar = input[i + 1]
      if char == nextChar
        i += 1
        next
      end
      if char.upcase == nextChar or char.downcase == nextChar
        input = input[0...i] + input[(i + 2)..]
        if i != 0
          i -= 2
        else
          i -= 1
        end
      end
      i += 1
      # puts i
    end
    best = [input.length, best].min
  end
  return best
end

puts part1(data)
puts part2(data)
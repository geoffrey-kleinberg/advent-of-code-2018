require 'set'

day = "02"
file_name = "12-#{day}-18/sampleIn.txt"
file_name = "12-#{day}-18/input.txt"

data = File.read(file_name).split("\n").map { |i| i.strip }

def containsN(str, n)
    for i in str.split("")
      if str.count(i) == n 
        return true
      end
    end
    return false
end

def part1(input)
    twos = 0
    threes = 0
    for line in input
      if containsN(line, 2)
        twos += 1
      end
      if containsN(line, 3)
        threes += 1
      end
    end
    return twos * threes
end

def countOff(str1, str2)
  count = 0
  for i in 0...str1.length
    if str1[i] != str2[i]
      count += 1
    end
  end

  return count
end

def getMatch(str1, str2)
    match = ""
    for i in 0...str1.length
      if str1[i] == str2[i]
        match += str1[i]
      end
    end
  
    return match
end

def part2(input)
    for i in input
      for j in input
        if countOff(i, j) == 1
          return getMatch(i, j)
        end
      end
    end
end

puts part1(data)
puts part2(data)
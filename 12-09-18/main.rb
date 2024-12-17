require 'set'

day = "09"
file_name = "12-#{day}-18/sampleIn.txt"
# file_name = "12-#{day}-18/input.txt"

data = File.read(file_name).split("\n").map { |i| i.strip }

def traverse(linkedList, n, start)
  cur = start
  for i in 0...n
    cur = linkedList[cur]
  end
  return cur
end

def printCirlce(linkedList, start)
  cur = start
  loop do
    print cur
    print " "
    cur = linkedList[cur]
    break if cur == start
  end
  puts
end

def part1(input)
    players = 479
    marbles = 71035
    scores = {}
    for i in 0...players
      scores[i] = 0
    end

    circleCW = {
        0 => 0
    }

    circleCCW = {
        0 => 0
    }

    currentMarble = 0

    player = 0

    for marble in 1..marbles
      if marble % 23 != 0
        left = circleCW[currentMarble]
        right = circleCW[left]
        circleCW[marble] = right
        circleCCW[marble] = left
        circleCW[left] = marble
        circleCCW[right] = marble
        currentMarble = marble
      else
        scores[player] += marble
        removed = traverse(circleCCW, 7, currentMarble)
        scores[player] += removed
        circleCW[circleCCW[removed]] = circleCW[removed]
        circleCCW[circleCW[removed]] = circleCCW[removed]
        currentMarble = circleCW[removed]
        circleCW.delete(removed)
        circleCCW.delete(removed)
      end
      player += 1
      player %= players
    end

    return scores.values.max
end

# kinda slow but not really that bad
def part2(input)
    players = 479
    marbles = 7103500
    scores = {}
    for i in 0...players
      scores[i] = 0
    end

    circleCW = {
        0 => 0
    }

    circleCCW = {
        0 => 0
    }

    currentMarble = 0

    player = 0

    for marble in 1..marbles
      if marble % 23 != 0
        left = circleCW[currentMarble]
        right = circleCW[left]
        circleCW[marble] = right
        circleCCW[marble] = left
        circleCW[left] = marble
        circleCCW[right] = marble
        currentMarble = marble
      else
        scores[player] += marble
        removed = traverse(circleCCW, 7, currentMarble)
        scores[player] += removed
        circleCW[circleCCW[removed]] = circleCW[removed]
        circleCCW[circleCW[removed]] = circleCCW[removed]
        currentMarble = circleCW[removed]
        circleCW.delete(removed)
        circleCCW.delete(removed)
      end
      player += 1
      player %= players
    end

    return scores.values.max
end

# puts part1(data)
puts part2(data)
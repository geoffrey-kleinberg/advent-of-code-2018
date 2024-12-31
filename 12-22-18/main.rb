require 'set'

day = "22"
file_name = "12-#{day}-18/sampleIn.txt"
file_name = "12-#{day}-18/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def getType(loc, depth, indices, erosions, types, target)
    if types[loc]
      return types[loc]
    end
  
    above = [loc[0] - 1, loc[1]]
    left = [loc[0], loc[1] - 1]
  
    x, y = loc

    if x == 0 and y == 0
      indices[loc] = 0
      erosions[loc] = depth % 20183
      types[loc] = erosions[loc] % 3
      return types[loc]
    end

    if target and target[0] == x and target[1] == y
      indices[loc] = 0
      erosions[loc] = depth % 20183
      types[loc] = erosions[loc] % 3
      return types[loc]
    end
  
    if y == 0
      indices[loc] = (16807 * x) % 20183
    elsif x == 0
      indices[loc] = (48271 * y) % 20183
    else
      if not erosions[above]
        getType(above, depth, indices, erosions, types, target)
      end
      if not erosions[left]
        getType(left, depth, indices, erosions, types, target)
      end
      indices[loc] = (erosions[above] * erosions[left]) % 20183
    end
  
    erosions[loc] = (indices[loc] + depth) % 20183
  
    types[loc] = erosions[loc] % 3

    return types[loc]
  
end

def part1(input)
    depth = input[0].split(" ")[1].to_i
    target = input[1].split(" ")[1].split(",").map { |i| i.to_i }

    geologicIndices = {}

    erosions = {}

    for x in 0..target[0]
      for y in 0..target[1]
        if [x, y] == [0, 0]
          geologicIndices[[x, y]] = 0
        elsif [x, y] == target
          geologicIndices[[x, y]] = 0
        elsif y == 0
          geologicIndices[[x, y]] = (16807 * x) % 20183
        elsif x == 0
          geologicIndices[[x, y]] = (48271 * y) % 20183
        else
          geologicIndices[[x, y]] = ((erosions[[x - 1, y]] * erosions[[x, y - 1]])) % 20183
        end
        erosions[[x, y]] = (geologicIndices[[x, y]] + depth) % 20183
      end
    end

    types = {}
    erosions.each do |k, v|
      types[k] = v % 3
    end

    return types.values.sum
end

def getHash(cur)
  return (2 ** cur[0][0]) * (3 ** cur[0][1]) * (5 ** cur[1])
end

def manhattan(p1, p2)
  return (p1[0] - p2[0]).abs + (p1[1] - p2[1]).abs
end

def part2(input)
    depth = input[0].split(" ")[1].to_i
    target = input[1].split(" ")[1].split(",").map { |i| i.to_i }

    geologicIndices = {}

    erosions = {}

    for y in 0..target[0]
      for x in 0..target[1]
        if [x, y] == [0, 0]
          geologicIndices[[x, y]] = 0
        elsif [x, y] == target
          geologicIndices[[x, y]] = 0
          erosions[[x, y]] = depth % 20183
        elsif y == 0
          geologicIndices[[x, y]] = (16807 * x) % 20183
        elsif x == 0
          geologicIndices[[x, y]] = (48271 * y) % 20183
        else
          geologicIndices[[x, y]] = ((erosions[[x - 1, y]] * erosions[[x, y - 1]])) % 20183
        end
        erosions[[x, y]] = (geologicIndices[[x, y]] + depth) % 20183
      end
    end

    types = {}
    erosions.each do |k, v|
      types[k] = v % 3
    end
    
    equipped = 1
    location = [0, 0]

    queue = {
        manhattan(location, target) => [[location, equipped, 0]]
    }
    best = manhattan(location, target)
    visited = Set[]

    while true
      if queue[best].length == 0
        queue.delete(best)
        best = queue.keys.min
      end
      curState = queue[best].shift

      next if visited.include? getHash(curState)

      visited.add(getHash(curState))

      curLoc = curState[0]
      curTool = curState[1]
      curTime = curState[2]
      curType = types[curLoc]

      if curLoc == target and curTool == 1
        return curTime
      end

      for t in 0..2
        next if t == curType
        heuristic = manhattan(curLoc, target) + curTime + 7
        if not queue[heuristic]
          queue[heuristic] = []
        end
        queue[heuristic].append([curLoc, t, curTime + 7])
      end

      for dir in [[0, 1], [0, -1], [1, 0], [-1, 0]]
        nextLoc = [curLoc[0] + dir[0], curLoc[1] + dir[1]]
        next if nextLoc.any? { |i| i < 0 }
        nextType = getType(nextLoc, depth, geologicIndices, erosions, types, target)
        next if nextType == curTool

        heuristic = manhattan(nextLoc, target) + curTime + 1
        if not queue[heuristic]
          queue[heuristic] = []
        end
        queue[heuristic].append([nextLoc, curTool, curTime + 1])
      end
    end
end

# puts part1(data)
puts part2(data)
require 'set'

day = "15"
file_name = "12-#{day}-18/sampleIn.txt"
file_name = "12-#{day}-18/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def manhattanDistance(a, b)
  return (a[0] - b[0]).abs + (a[1] - b[1]).abs
end

def readingOrderComparator(a, b)
  if (a[0] <=> b[0]) != 0
    return (a[0] <=> b[0])
  end
  return (a[1] <=> b[1])
end

def getNearestTarget(start, targets, occupied)
  nearest = []
  nearestDist = Float::INFINITY

  visited = occupied.clone
  visited.add(start)

  queue = [[start, 0]]

  while queue.length > 0
    cur = queue.shift
    curLoc = cur[0]
    curDist = cur[1]
    if curDist > nearestDist
      break
    end
    if nearest.length > targets.length
      break
    end
    if targets.include? curLoc
      nearestDist = curDist
      nearest.append(curLoc)
      next
    end
    for d in [[-1, 0], [0, -1], [0, 1], [1, 0]]
      nextLoc = [curLoc[0] + d[0], curLoc[1] + d[1]]
      next if visited.include? nextLoc
      visited.add(nextLoc)

      queue.append([nextLoc, curDist + 1])
    end
  end
  
  if nearest.length == 0
    return [false, -1]
  end

  return [nearest.sort { |a, b| readingOrderComparator(a, b) }[0], nearestDist]
end

# adapted from 2024 day 16 
# (time travel is this year's theme, after all)
def getNextStep(start, goal, dist, occupied)

    visited = {}

    dirs = {
        "E" => [0, 1],
        "N" => [-1, 0],
        "S" => [1, 0],
        "W" => [0, -1]
    }

    bestPaths = []
    queue = {
        manhattanDistance(start, goal) => [[[start], 0, start]]
    }

    while queue.keys.length > 0
      shortest = queue.keys.min
      cur = queue[shortest].shift
      if queue[shortest].length == 0
        queue.delete(shortest)
      end
      curPath = cur[0]
      score = cur[1]
      loc = cur[2]
      if loc == goal
        bestPaths.append(curPath)
      end

      for d in ["N", "W", "E", "S"]
        nextLoc = [loc[0] + dirs[d][0], loc[1] + dirs[d][1]]
        next if occupied.include? nextLoc
        next if visited[nextLoc] and visited[nextLoc] <= score
        visited[nextLoc] = score + 1

        heuristic = score + 1 + manhattanDistance(nextLoc, goal)

        next if heuristic > dist

        nextPath = curPath + [nextLoc]

        if not queue[heuristic]
          queue[heuristic] = []
        end
        queue[heuristic].append([nextPath, score + 1, nextLoc])
      end
    end

    return bestPaths.map { |i| i[1] }.sort { |a, b| readingOrderComparator(a, b) }[0]
end

def getNeighbors(units, occupied)
  neighbors = Set[]
  for u in units
    for d in [[-1, 0], [0, -1], [0, 1], [1, 0]]
      neighbor = [u[0] + d[0], u[1] + d[1]]
      next if occupied.include? neighbor
      neighbors.add(neighbor)
    end
  end
  return neighbors
end

def simulateBattle(input, elfPower)
    allUnits = []
    elves = Set[]
    goblins = Set[]
    occupied = Set[]
    hashtags = Set[]

    for i in 0...input.length
      for j in 0...input[i].length
        if input[i][j] == "#"
          occupied.add([i, j])
          hashtags.add([i, j])
        end
        if input[i][j] == "E"
          occupied.add([i, j])
          elves.add([i, j])
          allUnits.append([[i, j], "E", 200])
        end
        if input[i][j] == "G"
          occupied.add([i, j])
          goblins.add([i, j])
          allUnits.append([[i, j], "G", 200])
        end
      end
    end

    round = 0

    while elves.size > 0 and goblins.size > 0
      puts round
      allUnits = allUnits.sort { |a, b| readingOrderComparator(a[0], b[0]) }

      idx = 0

      while idx < allUnits.length
        unit = allUnits[idx]
        type = unit[1]
        health = unit[2]
        targets = (type == "E") ? getNeighbors(goblins, hashtags) : getNeighbors(elves, hashtags)
        if targets.length == 0
            return [round * allUnits.sum { |i| i[2] }, elves.size]
        end
        # MOVE PHASE
        if not targets.include? unit[0]
            targets = (type == "E") ? getNeighbors(goblins, occupied) : getNeighbors(elves, occupied)
            t, d = getNearestTarget(unit[0], targets, occupied)
            if not t
                idx += 1
                # turn ends because there is no move to make
                next
            end
            moveTo = getNextStep(unit[0], t, d, occupied)
            occupied.delete(unit[0])
            occupied.add(moveTo)
            if type == "E"
                elves.delete(unit[0])
                elves.add(moveTo)
            else
                goblins.delete(unit[0])
                goblins.add(moveTo)
            end
            unit[0] = moveTo
            allUnits[idx] = [moveTo, type, health]
        end
        targets = (type == "E") ? getNeighbors(goblins, hashtags) : getNeighbors(elves, hashtags)

        # ATTACK PHASE
        if targets.include? unit[0]
          possible = allUnits.filter do |i|
            (manhattanDistance(i[0], unit[0]) == 1) and (i[1] != unit[1])
          end
          minimumHP = possible.min { |i, j| i[2] <=> j[2] }[2]
          toAttack = possible.filter { |i| i[2] == minimumHP }.sort { |a, b| readingOrderComparator(a, b) }[0]
          if unit[1] == "G"
            toAttack[2] -= 3
          elsif unit[1] == "E"
            toAttack[2] -= elfPower
          else
            raise "oops"
          end
          if toAttack[2] <= 0
            deadIdx = allUnits.index(toAttack)
            if deadIdx < idx
              idx -= 1
            end
            deadIdx = Float::INFINITY
            location = toAttack[0]
            type = toAttack[1]
            if type == "E"
                elves.delete(location)
            else
                goblins.delete(location)
            end
            occupied.delete(location)
            allUnits.delete(toAttack)
          end
        end

        idx += 1
      end
      round += 1
    end

    # puts round
    # puts allUnits.sum { |i| i[2] }
    # print allUnits
    # puts
    return [round * allUnits.sum { |i| i[2] }, elves.size]
end

def part1(input)
    return simulateBattle(input, 3)[0]
end

def part2(input)
    power = 4
    elves = input.map { |i| i.split("") }.flatten.count("E")
    while true
        puts power
        score, elvesLeft =  simulateBattle(input, power)
        if elves == elvesLeft
          return score
        end
        power += 1
    end
end

# puts part1(data)
puts part2(data)
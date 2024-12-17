require 'set'

day = "06"
file_name = "12-#{day}-18/sampleIn.txt"
file_name = "12-#{day}-18/input.txt"

data = File.read(file_name).split("\n").map { |i| i.strip }

def manhattanDistance(p1, p2)
  return (p1[0] - p2[0]).abs + (p1[1] - p2[1]).abs
end

def getArea(p, locs)
  queue = [p]
  region = Set[]
  visited = Set[p]

  maxIter = 20000
  iter = 0

  while queue.length > 0
    break if iter >= maxIter
    iter += 1
    cur = queue.shift

    # print cur
    # puts
    # puts manhattanDistance(cur, p)
    region.add(cur)

    for d in [[0, 1], [1, 0], [0, -1], [-1, 0]]
      nextLoc = [cur[0] + d[0], cur[1] + d[1]]

      next if visited.include? nextLoc

      visited.add(nextLoc)
      
    #   if nextLoc == [68, 124]
    #     puts "here"
    #   end

      dist = manhattanDistance(p, nextLoc)
      closest = true

      for l in locs
        thisDist = manhattanDistance(l, nextLoc)
        if thisDist <= dist and l != p
          closest = false
        end
      end
      next if not closest
      queue.append(nextLoc)
    end
    
  end

  return region.size
end

def part1(input)
    locs = input.map { |i| i.split(", ").map { |j| j.to_i }}

    xMin, xMax = locs.minmax { |i, j| i[0] <=> j[0] }.map { |i| i[0] }
    yMin, yMax = locs.minmax { |i, j| i[0] <=> j[0] }.map { |i| i[0] }

    boundingBox = Set[]
    for x in xMin..xMax
      boundingBox.add([x, yMin])
      boundingBox.add([x, yMax])
    end
    for y in yMin..yMax
        boundingBox.add([xMin, y])
        boundingBox.add([xMax, y])
    end

    nearest = {

    }
    for b in boundingBox
      shortestDist = Float::INFINITY
      for l in locs
        d = manhattanDistance(b, l)
        if d < shortestDist
          shortestDist = d
          nearest[b] = d
        end
      end
    end

    nearestPts = {

    }
    for b in boundingBox
      nearestPts[b] = []
      for l in locs
        if manhattanDistance(b, l) == nearest[b]
          nearestPts[b].append(l)
        end
      end
    end

    infinite = Set[]
    for k in nearestPts.values
      infinite.add(k[0]) if k.length == 1
    end

    finite = []

    for l in locs
      finite.append(l) if not infinite.include? l
    end

    areas = {}

    for l in finite
      areas[l] = getArea(l, locs)
    end
    return areas.values.max
end

def part2(input)

    # this just does a flood fill, assumes that the region is contiguous
    # I think that is a valid assumption but not sure it works in general

    locs = input.map { |i| i.split(", ").map { |j| j.to_i }}

    
    valid = Set[]
    seed = nil
    seen = Set[]

    for l1 in locs
      total = 0
      for l2 in locs
        total += manhattanDistance(l1, l2)
      end
      if total < 10000
        seed = l1
        break
      end
    end

    queue = [seed]

    while queue.length > 0
      cur = queue.shift
      valid.add(cur)

      for dir in [[0, 1], [1, 0], [0, -1], [-1, 0]]
        nextLoc = [cur[0] + dir[0], cur[1] + dir[1]]
        next if valid.include? nextLoc
        next if seen.include? nextLoc
        seen.add(nextLoc)

        total = 0
        for l in locs
          total += manhattanDistance(l, nextLoc)
        end
        next if total >= 10000
        queue.append(nextLoc)
      end
    end

    return valid.size

    
end

# puts part1(data)
puts part2(data)
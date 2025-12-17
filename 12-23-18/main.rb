require 'set'

day = "23"
file_name = "12-#{day}-18/sampleIn.txt"
file_name = "12-#{day}-18/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def manhattan(p1, p2)
  total = 0
  for i in 0...p1.length
    total += (p1[i] - p2[i]).abs
  end
  return total
end

def part1(input)
    bots = []
    for line in input
      p1, p2 = line.split(">, ")
      range = p2.split("=")[1].to_i
      pos = p1.split("<")[1].split(",").map { |i| i.to_i }
      bots.append([pos, range])
    end

    strongest = bots.max { |i, j| i[1] <=> j[1] }
    power = 0
    for i in 0...bots.length
      d = manhattan(strongest[0], bots[i][0])
      if d <= strongest[1]
        power += 1
      end
    end

    return power
end

def toOrigin(i)
  return i[0].map { |j| j.abs }.sum - i[1]
end

def getBotsInRange(x, y, z, bots)
  numBots = 0
  for i in 0...bots.length
    d = manhattan([x, y, z], bots[i][0])
    if d <= bots[i][1]
      numBots += 1
    end
  end
  return numBots
end

def doesBotTouchFace(xRange, yRange, zRange, bot)
  for x in xRange[0]..xRange[1]
    for y in yRange[0]..yRange[1]
      for z in zRange[0]..zRange[1]
        dist = manhattan([x, y, z], bot[0])
        if dist <= bot[1]
          return true
        end
      end
    end
  end

  return false

end

def getBotsTouchingPrism(xRange, yRange, zRange, bots)
  touching = 0
  for b in bots
    xDist = xRange.map { |x| x - b[0][0] }
    yDist = yRange.map { |y| y - b[0][1] }
    zDist = zRange.map { |z| z - b[0][2] }

    # p xDist
    # p yDist
    # p zDist
    # puts

    rad = 0

    if 0 <= xDist.max or 0 >= xDist.min
      rad += xDist.map { |x| x.abs }.min
    end
    if 0 <= yDist.max or 0 >= yDist.min
      rad += yDist.map { |y| y.abs }.min
    end
    if 0 <= zDist.max or 0 >= zDist.min
      rad += zDist.map { |z| z.abs }.min
    end
    
    # puts rad
    # puts

    valid = b[1] >= rad
    
    if valid
      touching += 1
    end


  end

  return touching
end

def getBestPointInPrism(xRange, yRange, zRange, bots)
  # cut the prism into 8 sub-prisms
  # find how many bots touch each sub-prism
  # find the sub-prism corresponding to the highest value
  # get best point in there

  if xRange.uniq.length == 1 and yRange.uniq.length == 1 and zRange.uniq.length == 1
    return [xRange[0], yRange[0], zRange[0]]
  end

  xDiff = (xRange[1] - xRange[0]) / 2
  yDiff = (yRange[1] - yRange[0]) / 2
  zDiff = (zRange[1] - zRange[0]) / 2

  xChoices = [xRange[0], xRange[0] + xDiff, xRange[1]]
  yChoices = [yRange[0], yRange[0] + yDiff, yRange[1]]
  zChoices = [zRange[0], zRange[0] + zDiff, zRange[1]]

  if xRange[1] != xRange[0]
    xChoices.insert(2, xRange[0] + xDiff + 1)
  else
    xChoices.insert(2, xRange[0])
  end
  if yRange[1] != yRange[0]
    yChoices.insert(2, yRange[0] + yDiff + 1)
  else
    yChoices.insert(2, yRange[0])
  end
  if zRange[0] != zRange[1]
    zChoices.insert(2, zRange[0] + zDiff + 1)
  else
    zChoices.insert(2, zRange[0])
  end

  bestIdx = []
  bestNum = 0

  for x in 0..1
    for y in 0..1
      for z in 0..1
        numDetecting = getBotsTouchingPrism(xChoices[(x * 2)..(x * 2 + 1)], yChoices[(y * 2)..(y * 2 + 1)], zChoices[(z * 2)..(z * 2 + 1)], bots)
        if numDetecting > bestNum
          bestNum = numDetecting
          bestIdx = [x, y, z]
        end
      end
    end
  end
  xHalf = bestIdx[0]
  yHalf = bestIdx[1]
  zHalf = bestIdx[2]

  xRangeNew = xChoices[(xHalf * 2)..(xHalf * 2 + 1)]
  yRangeNew = yChoices[(yHalf * 2)..(yHalf * 2 + 1)]
  zRangeNew = zChoices[(zHalf * 2)..(zHalf * 2 + 1)]

  return getBestPointInPrism(xRangeNew, yRangeNew, zRangeNew, bots)
  
end

def part2(input)

    bots = []
    for line in input
      p1, p2 = line.split(">, ")
      range = p2.split("=")[1].to_i
      pos = p1.split("<")[1].split(",").map { |i| i.to_i }
      bots.append([pos, range])
    end

    xRange = bots.minmax { |i, j| i[0][0] <=> j[0][0] }.map { |i| i[0][0] }
    yRange = bots.minmax { |i, j| i[0][1] <=> j[0][1] }.map { |i| i[0][1] }
    zRange = bots.minmax { |i, j| i[0][2] <=> j[0][2] }.map { |i| i[0][2] }
    bestPoint = getBestPointInPrism(xRange, yRange, zRange, bots)

    # puts getBotsInRange(bestPoint[0], bestPoint[1], bestPoint[2], bots)
    return bestPoint.map { |i| i.abs }.sum
end

puts part1(data)
puts part2(data)

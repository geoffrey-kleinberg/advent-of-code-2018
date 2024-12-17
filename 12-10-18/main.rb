require 'set'

day = "10"
file_name = "12-#{day}-18/sampleIn.txt"
file_name = "12-#{day}-18/input.txt"

data = File.read(file_name).split("\n").map { |i| i.strip }

def printAll(points)
  xMin, xMax = points.minmax { |i, j| i[0] <=> j[0] }.map { |i| i[0] }
  yMin, yMax = points.minmax { |i, j| i[1] <=> j[1] }.map { |i| i[1] }

  for y in yMin..yMax
    for x in xMin..xMax
      if points.include? [x, y]
        print "#"
      else
        print "."
      end
    end
    puts
  end
end

def part1(input)

    positions = []
    vels = []

    for line in input
      _, ls, vs = line.split("<")
      x0, y0, _ = ls.split(" ").map { |i| i.to_i }
      vx, vy = vs.split(" ").map { |i| i.to_i }
      positions.append([x0, y0])
      vels.append([vx, vy])
    end

    smallestXVar = Float::INFINITY

    t = 0
    while true
      newPositions = []
      for i in 0...positions.length
        p = positions[i]
        v = vels[i]
        newPositions.append([p[0] + t * v[0], p[1] + t * v[1]])
      end

      xMin, xMax = newPositions.minmax { |i, j| i[0] <=> j[0] }.map { |i| i[0] }
      if xMax - xMin <= smallestXVar
        smallestXVar = xMax - xMin
      else
        t -= 1
        break
      end

      t += 1
    end
    
    newPositions = []
    for i in 0...positions.length
        p = positions[i]
        v = vels[i]
        newPositions.append([p[0] + t * v[0], p[1] + t * v[1]])
    end

    printAll(newPositions)

    return nil
end

def part2(input)
    positions = []
    vels = []

    for line in input
      _, ls, vs = line.split("<")
      x0, y0, _ = ls.split(" ").map { |i| i.to_i }
      vx, vy = vs.split(" ").map { |i| i.to_i }
      positions.append([x0, y0])
      vels.append([vx, vy])
    end

    smallestXVar = Float::INFINITY

    t = 0
    while true
      newPositions = []
      for i in 0...positions.length
        p = positions[i]
        v = vels[i]
        newPositions.append([p[0] + t * v[0], p[1] + t * v[1]])
      end

      xMin, xMax = newPositions.minmax { |i, j| i[0] <=> j[0] }.map { |i| i[0] }
      if xMax - xMin <= smallestXVar
        smallestXVar = xMax - xMin
      else
        t -= 1
        break
      end

      t += 1
    end

    return t
end

puts part1(data)
# puts part2(data)
require 'set'

day = "11"
file_name = "12-#{day}-18/sampleIn.txt"
# file_name = "12-#{day}-18/input.txt"

data = File.read(file_name).split("\n").map { |i| i.strip }

def part1(input)
    serial = 8141

    powers = {}

    for x in 1..300
      for y in 1..300
        rackId = x + 10
        power = rackId * y
        power += serial
        power *= rackId
        power = (power / 100) % 10
        power -= 5
        powers[[x, y]] = power
      end
    end

    highestSquare = -1 * Float::INFINITY
    highestLoc = nil
    for x in 1..298
      for y in 1..298
        total = 0
        for dx in 0..2
          for dy in 0..2
            total += powers[[x + dx, y + dy]]
          end
        end
        if total > highestSquare
          highestSquare = total
          highestLoc = [x, y]
        end
      end
    end

    return highestLoc.join(",")
end

# very slow but it does the trick
# optimize with https://en.wikipedia.org/wiki/Summed-area_table

def part2(input)
    serial = 8141

    powers = {}
    gridAreas = {}

    for x in 1..300
      for y in 1..300
        rackId = x + 10
        power = rackId * y
        power += serial
        power *= rackId
        power = (power / 100) % 10
        power -= 5
        powers[[x, y]] = power
        gridAreas[[x, y, 1]] = power
      end
    end

    highestSquare = -1 * Float::INFINITY
    highestLoc = nil
    
    for size in 2..300
      puts size
      division = 1
      for d in 2...size
        if size % d == 0
          division = d
        end
      end
      for x in 1..(301 - size)
        for y in 1..(301 - size)
          power = gridAreas[[x, y, size - division]]
          (0...size).step(division) do |d|
            power += gridAreas[[x + size - division, y + d, division]]
            next if d == size - division
            power += gridAreas[[x + d, y + size - division, division]]
          end
          gridAreas[[x, y, size]] = power

          if power > highestSquare
            highestSquare = power
            highestLoc = [x, y, size]
          end
        end
      end
    end

    return highestLoc.join(",")
end

def part2SummedAreaTable(input)
    serial = 8141

    powers = {}

    for x in 1..300
      for y in 1..300
        rackId = x + 10
        power = rackId * y
        power += serial
        power *= rackId
        power = (power / 100) % 10
        power -= 5
        powers[[x, y]] = power
      end
    end
    
    puts "powers"

    summedAreaTable = {}
    summedAreaTable.default = 0
    for x in 1..300
      for y in 1..300       
        summedAreaTable[[x, y]] = summedAreaTable[[x - 1, y]] + summedAreaTable[[x, y - 1]] - summedAreaTable[[x - 1, y - 1]] + powers[[x, y]]
      end
    end

    puts "area table"

    highestSquare = -1 * Float::INFINITY
    highestLoc = nil

    for size in 1..300
      for x in 1..(301 - size)
        for y in 1..(301 - size)

          # calculate power using summed area table
          xMax = x + size - 1
          yMax = y + size - 1

          power = summedAreaTable[[xMax, yMax]] - summedAreaTable[[x - 1, yMax]] - summedAreaTable[[xMax, y - 1]] + summedAreaTable[[x - 1, y - 1]]

          if power > highestSquare
            highestSquare = power
            highestLoc = [x, y, size]
          end
        end
      end
    end

    return highestLoc.join(",")

end

# puts part1(data)
# puts part2(data)
puts part2SummedAreaTable(data)
require 'set'

day = "03"
file_name = "12-#{day}-18/sampleIn.txt"
file_name = "12-#{day}-18/input.txt"

data = File.read(file_name).split("\n").map { |i| i.strip }

# 134285 too high
# 96240 too low

def part1(input)
    claims = {}

    for line in input
      id, rem = line.split(" @ ")
      id = id[1..].to_i

      loc, area = rem.split(": ")

      loc = loc.split(",").map { |i| i.to_i }

      area = area.split("x").map { |i| i.to_i }

      claims[id] = [loc.clone, area.clone]
    end

    numClaimed = {}

    claims.each do |k, v|
      xStart = v[0][0]
      yStart = v[0][1]

      xEnd = v[0][0] + v[1][0]
      yEnd = v[0][1] + v[1][1]

      for i in xStart...xEnd
        for j in yStart...yEnd
          if not numClaimed[[i, j]]
            numClaimed[[i, j]] = 0
          end
          numClaimed[[i, j]] += 1
        end
      end
    end

    return numClaimed.count { |k, v| v >= 2 }
end

def part2(input)
    claims = {}

    for line in input
      id, rem = line.split(" @ ")
      id = id[1..].to_i

      loc, area = rem.split(": ")

      loc = loc.split(",").map { |i| i.to_i }

      area = area.split("x").map { |i| i.to_i }

      claims[id] = [loc.clone, area.clone]
    end

    claimedBy = {}

    whole = Set[]

    claims.each do |k, v|
      whole.add(k)

      xStart = v[0][0]
      yStart = v[0][1]

      xEnd = v[0][0] + v[1][0]
      yEnd = v[0][1] + v[1][1]

      for i in xStart...xEnd
        for j in yStart...yEnd
          if claimedBy[[i, j]]
            if whole.include? claimedBy[[i, j]]
              whole.delete(claimedBy[[i, j]])
            end
            whole.delete(k)
          else
            claimedBy[[i, j]] = k
          end
        end
      end
    end

    puts whole.size

    return whole.to_a[0]
end

# puts part1(data)
puts part2(data)
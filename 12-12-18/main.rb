require 'set'

day = "12"
file_name = "12-#{day}-18/sampleIn.txt"
file_name = "12-#{day}-18/input.txt"

data = File.read(file_name).split("\n").map { |i| i.strip }

def part1(input)
    initial_state = "#..#.#..##......###...###"
    initial_state = "##.####..####...#.####..##.#..##..#####.##.#..#...#.###.###....####.###...##..#...##.#.#...##.##.."
    

    newPlantNums = Set[]
    for line in input
      pattern, result = line.split(" => ")
      pattern = pattern.split("").map { |i| i == "#" ? "1" : "0" }.join.to_i(2)
      if result == "#"
        newPlantNums.add(pattern)
      end
    end

    plants = Set[]
    
    for i in 0...initial_state.length
      if initial_state[i] == "#"
        plants.add(i)
      end
    end

    first = plants.min - 2
    last = plants.max + 2

    for iter in 0...20
      newPlants = Set[]
      for loc in first..last
        val = 0
        for d in -2..2
          if plants.include? (loc + d)
            val += 2 ** (4 - (d + 2))
          end
        end
        if newPlantNums.include? val
          newPlants.add(loc)
        end
      end
      plants = newPlants
      first = plants.min - 2
      last = plants.max + 2
    end

    return plants.sum
end

def part2(input)
    initial_state = "#..#.#..##......###...###"
    initial_state = "##.####..####...#.####..##.#..##..#####.##.#..#...#.###.###....####.###...##..#...##.#.#...##.##.."
    

    newPlantNums = Set[]
    for line in input
      pattern, result = line.split(" => ")
      pattern = pattern.split("").map { |i| i == "#" ? "1" : "0" }.join.to_i(2)
      if result == "#"
        newPlantNums.add(pattern)
      end
    end

    plants = Set[]
    
    for i in 0...initial_state.length
      if initial_state[i] == "#"
        plants.add(i)
      end
    end

    first = plants.min - 2
    last = plants.max + 2

    iter = 0
    prev = plants.sum
    diff = nil
    prevdiff = nil
    prevprevdiff = nil

    while true
      iter += 1
      newPlants = Set[]
      for loc in first..last
          val = 0
          for d in -2..2
            if plants.include? (loc + d)
              val += 2 ** (4 - (d + 2))
            end
          end
          if newPlantNums.include? val
            newPlants.add(loc)
          end
      end
      plants = newPlants
      diff = plants.sum - prev
      prev = plants.sum
      if diff == prevdiff and prevdiff == prevprevdiff
        break
      end
      prevprevdiff = prevdiff
      prevdiff = diff
      first = plants.min - 2
      last = plants.max + 2
    end

    # puts plants.sum

    # puts iter

    return plants.sum + (50000000000 - iter) * diff

end

# puts part1(data)
puts part2(data)
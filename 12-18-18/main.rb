require 'set'

day = "18"
file_name = "12-#{day}-18/sampleIn.txt"
file_name = "12-#{day}-18/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def getGrid(grid, i, j)
  if i >= 0 and i < grid.length and j >= 0 and j < grid[i].length
    return grid[i][j]
  end
  return nil
end

def update(grid)
  newGrid = []
  for i in 0...grid.length
    newGrid.append([])
    for j in 0...grid[i].length
      adjTrees = 0
      adjLum = 0
      for di in -1..1
        for dj in -1..1
          next if di == 0 and dj == 0
          if getGrid(grid, i + di, j + dj) == "|"
            adjTrees += 1
          end
          if getGrid(grid, i + di, j + dj) == "#"
            adjLum += 1
          end
        end
      end
      if grid[i][j] == "."
        if adjTrees >= 3
          newGrid[i].append("|")
        else
          newGrid[i].append(".")
        end
      end
      if grid[i][j] == "|"
        if adjLum >= 3
          newGrid[i].append("#")
        else
          newGrid[i].append("|")
        end
      end
      if grid[i][j] == "#"
        if adjLum >= 1 and adjTrees >= 1
          newGrid[i].append("#")
        else
          newGrid[i].append(".")
        end
      end
    end
  end
  return newGrid
end

def part1(input)
    grid = []
    for line in input
        grid.append(line.split("") )
    end

    10.times do
      grid = update(grid)
    end
    flat = grid.flatten
    return flat.count("|") * flat.count("#")
end

def part2(input)
    grid = []
    for line in input
        grid.append(line.split("") )
    end

    seen = {}

    iter = 0

    while true
      seen[grid.flatten.join] = iter
      grid = update(grid)
      iter += 1
      if seen[grid.flatten.join]
        cycle = iter - seen[grid.flatten.join]
        first = seen[grid.flatten.join]
        break
      end
    end

    toDo = (1000000000 - first) % cycle

    toDo.times do
      grid = update(grid)
    end

    flat = grid.flatten
    return flat.count("|") * flat.count("#")
end

puts part1(data)
puts part2(data)
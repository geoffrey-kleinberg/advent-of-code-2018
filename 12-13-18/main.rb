require 'set'

day = "13"
file_name = "12-#{day}-18/sampleIn.txt"
file_name = "12-#{day}-18/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

# 0 left
# 1 straight
# 2 right

def part1(input)
    minecarts = []
    grid = input.map { |i| i.split("") }

    left = {
        [0, 1] => [-1, 0],
        [-1, 0] => [0, -1],
        [0, -1] => [1, 0],
        [1, 0] => [0, 1]
    }

    right = {
        [-1, 0] => [0, 1],
        [0, 1] => [1, 0],
        [1, 0] => [0, -1],
        [0, -1] => [-1, 0]
    }

    for i in 0...grid.length
      for j in 0...grid[i].length
        if grid[i][j] == ">"
          minecarts.append([[i, j], [0, 1], 0])
        end
        if grid[i][j] == "<"
            minecarts.append([[i, j], [0, -1], 0])
        end
        if grid[i][j] == "v"
          minecarts.append([[i, j], [1, 0], 0])
        end
        if grid[i][j] == "^"
            minecarts.append([[i, j], [-1, 0], 0])
        end
      end
    end

    order = minecarts.sort { |i, j| ((i[0][0] <=> j[0][0]) == 0) ? (i[0][1] <=> j[0][1]) : (i[0][0] <=> j[0][0])}


    minecartLocs = minecarts.map { |i| i[0] }.to_set

    while true
      for cart in order

        cartLoc = cart[0]
        cartDir = cart[1]
        turnCode = cart[2]

        tile = grid[cartLoc[0]][cartLoc[1]]

        if tile == "\\" and cartDir[0] == 0
          cartDir = right[cartDir]
        elsif tile == "\\" and cartDir[1] == 0
          cartDir = left[cartDir]
        end
        if tile == "/" and cartDir[0] == 0
          cartDir = left[cartDir]
        elsif tile == "/" and cartDir[1] == 0
          cartDir = right[cartDir]
        end

        if tile == "+"
          if turnCode == 0
            cartDir = left[cartDir]
          end
          if turnCode == 2
            cartDir = right[cartDir]
          end
          turnCode += 1
          turnCode %= 3
        end

        newLoc = [cartLoc[0] + cartDir[0], cartLoc[1] + cartDir[1]]
        minecartLocs.delete(cartLoc)
        if not minecartLocs.add?(newLoc)
          return newLoc.reverse.join(",")
        end
        cart[0] = newLoc
        cart[1] = cartDir
        cart[2] = turnCode

      end
    #   print minecartLocs
    #   puts
      order = minecarts.sort { |i, j| ((i[0][0] <=> j[0][0]) == 0) ? (i[0][1] <=> j[0][1]) : (i[0][0] <=> j[0][0])}
    end
end

def part2(input)
    minecarts = []
    grid = input.map { |i| i.split("") }

    left = {
        [0, 1] => [-1, 0],
        [-1, 0] => [0, -1],
        [0, -1] => [1, 0],
        [1, 0] => [0, 1]
    }

    right = {
        [-1, 0] => [0, 1],
        [0, 1] => [1, 0],
        [1, 0] => [0, -1],
        [0, -1] => [-1, 0]
    }

    for i in 0...grid.length
      for j in 0...grid[i].length
        if grid[i][j] == ">"
          minecarts.append([[i, j], [0, 1], 0])
        end
        if grid[i][j] == "<"
            minecarts.append([[i, j], [0, -1], 0])
        end
        if grid[i][j] == "v"
          minecarts.append([[i, j], [1, 0], 0])
        end
        if grid[i][j] == "^"
            minecarts.append([[i, j], [-1, 0], 0])
        end
      end
    end

    order = minecarts.sort { |i, j| ((i[0][0] <=> j[0][0]) == 0) ? (i[0][1] <=> j[0][1]) : (i[0][0] <=> j[0][0])}


    minecartLocs = minecarts.map { |i| i[0] }.to_set

    while true
      for cart in order

        cartLoc = cart[0]
        cartDir = cart[1]
        turnCode = cart[2]

        tile = grid[cartLoc[0]][cartLoc[1]]

        if tile == "\\" and cartDir[0] == 0
          cartDir = right[cartDir]
        elsif tile == "\\" and cartDir[1] == 0
          cartDir = left[cartDir]
        end
        if tile == "/" and cartDir[0] == 0
          cartDir = left[cartDir]
        elsif tile == "/" and cartDir[1] == 0
          cartDir = right[cartDir]
        end

        if tile == "+"
          if turnCode == 0
            cartDir = left[cartDir]
          end
          if turnCode == 2
            cartDir = right[cartDir]
          end
          turnCode += 1
          turnCode %= 3
        end

        newLoc = [cartLoc[0] + cartDir[0], cartLoc[1] + cartDir[1]]
        minecartLocs.delete(cartLoc)
        cart[0] = newLoc
        cart[1] = cartDir
        cart[2] = turnCode
        if minecartLocs.include? newLoc
          minecarts.delete_if { |i| i[0] == newLoc }
          minecartLocs = minecarts.map { |i| i[0] }.to_set
        else
          minecartLocs.add(newLoc)
        end

      end
      if minecarts.length == 1
        return minecarts[0][0].reverse.join(",")
      end
      if minecarts.length == 0
        return -1
      end
      order = minecarts.sort { |i, j| ((i[0][0] <=> j[0][0]) == 0) ? (i[0][1] <=> j[0][1]) : (i[0][0] <=> j[0][0])}
    end
end

# puts part1(data)
puts part2(data)
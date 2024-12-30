require 'set'

day = "20"
file_name = "12-#{day}-18/sampleIn.txt"
file_name = "12-#{day}-18/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def getLongestPath(graph, cur, prev)
  count = 0
  if graph[cur].length == 1 and not graph[cur].include? prev
    count += 1
    prev = cur
    cur = graph[cur][0]
  end

  while graph[cur].length == 2
    temp = graph[cur].filter { |i| i != prev }[0]
    prev = cur
    cur = temp
    count += 1
  end

  if graph[cur].length == 1
    return count
  end

  longest = -1
  for i in graph[cur]
    next if i == prev
    longest = [longest, count + 1 + getLongestPath(graph, i, cur)].max
  end
  return longest
end

def part1(input)

    input = input[0][1...-1]
    location = [0, 0]
    # uses coordinate XY with (0, 0) as start point
    dirMap = {
        "N" => [0, 1],
        "E" => [1, 0],
        "S" => [0, -1],
        "W" => [-1, 0]
    }
    branches = []

    graph = {}

    for char in input.split("")
      if dirMap.keys.include? char
        mvmt = dirMap[char]
        nextLoc = [location[0] + mvmt[0], location[1] + mvmt[1]]
        if not graph[location]
          graph[location] = []
        end
        if not graph[nextLoc]
          graph[nextLoc] = []
        end
        if not graph[location].include? nextLoc
          graph[location].append(nextLoc)
        end
        if not graph[nextLoc].include? location
          graph[nextLoc].append(location)
        end
        location = nextLoc
      elsif char == "("
        branches.append(location)
      elsif char == ")"
        branches.delete_at(-1)
      elsif char == "|"
        location = branches[-1]
      end
    end

    return getLongestPath(graph, [0, 0], nil)
end

def makePathLengths(graph, start)
  lengths = {}
  lengths[start] = 0

  queue = [[start, graph[start][0]]]
  visited = Set[]
  visited.add(start)
  while queue.length > 0
    place = queue.shift
    prev, cur = place
    visited.add(cur)
    lengths[cur] = lengths[prev] + 1

    for i in graph[cur]
      next if visited.include? i
      queue.append([cur, i])
    end
  end
  return lengths
end

def part2(input)
    input = input[0][1...-1]
    location = [0, 0]
    # uses coordinate XY with (0, 0) as start point
    dirMap = {
        "N" => [0, 1],
        "E" => [1, 0],
        "S" => [0, -1],
        "W" => [-1, 0]
    }
    branches = []

    graph = {}

    for char in input.split("")
      if dirMap.keys.include? char
        mvmt = dirMap[char]
        nextLoc = [location[0] + mvmt[0], location[1] + mvmt[1]]
        if not graph[location]
          graph[location] = []
        end
        if not graph[nextLoc]
          graph[nextLoc] = []
        end
        if not graph[location].include? nextLoc
          graph[location].append(nextLoc)
        end
        if not graph[nextLoc].include? location
          graph[nextLoc].append(location)
        end
        location = nextLoc
      elsif char == "("
        branches.append(location)
      elsif char == ")"
        branches.delete_at(-1)
      elsif char == "|"
        location = branches[-1]
      end
    end

    lengths = makePathLengths(graph, [0, 0])

    return lengths.filter { |k, v| v >= 1000 }.size
end

puts part1(data)
puts part2(data)
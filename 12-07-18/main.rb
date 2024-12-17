require 'set'

day = "07"
file_name = "12-#{day}-18/sampleIn.txt"
file_name = "12-#{day}-18/input.txt"

data = File.read(file_name).split("\n").map { |i| i.strip }

def part1(input)
    requires = {}
    steps = Set[]
    for line in input
      spl = line.split(" ")
      first = spl[1]
      second = spl[-3]
      steps.add(first)
      steps.add(second)
      if not requires[second]
        requires[second] = Set[]
      end
      requires[second].add(first)
    end

    for s in steps
      if not requires[s]
        requires[s] = Set[]
      end
    end

    order = []
    while order.length < steps.size
      available = requires.filter { |k, v| v.size == 0 }.keys.sort
      cur = available[0]
      order.append(cur)
      requires.delete(cur)
      for k in requires.keys
        requires[k].delete(cur)
      end
    end

    return order.join

end

def part2(input)
    requires = {}
    steps = Set[]
    for line in input
      spl = line.split(" ")
      first = spl[1]
      second = spl[-3]
      steps.add(first)
      steps.add(second)
      if not requires[second]
        requires[second] = Set[]
      end
      requires[second].add(first)
    end

    for s in steps
      if not requires[s]
        requires[s] = Set[]
      end
    end

    finished = []

    offset = 60

    times = {}
    for letter in steps
      times[letter] = letter.ord - 64 + offset
    end

    numWorkers = 5

    working = {
    }

    time = 0
    while finished.length < steps.size
    #   puts time
      for step in times.keys
        if times[step] == 0
          working[working[step]] = nil
          working.delete(step)
          finished.append(step)
          times.delete(step)
          for k in requires.keys
            requires[k].delete(step)
          end
        end
      end
      break if finished.length == steps.size
      available = requires.filter { |k, v| v.size == 0 }.keys.sort
    #   print available
    #   puts
    #   print working
    #   puts
      for w in 0...numWorkers
        if not working[w]
          working[w] = available.shift
          working[working[w]] = w
          requires.delete(working[w])
        end
        break if available.length < 1
      end
    #   print working
    #   puts
      for w in 0...numWorkers
        if working[w]
          times[working[w]] -= 1
        end
      end
    #   print times
    #   puts 
    #   puts 
      time += 1
    #   break if time >= 16
    end

    puts finished.join

    return time

end

# puts part1(data)
puts part2(data)
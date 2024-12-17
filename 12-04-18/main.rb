require 'set'

day = "04"
file_name = "12-#{day}-18/sampleIn.txt"
file_name = "12-#{day}-18/input.txt"

data = File.read(file_name).split("\n").map { |i| i.strip }

def timeToArray(t)
    d = t.split(" ")
    d[0] = d[0].split("-").map { |i| i.to_i }
    d[1] = d[1].split(":").map { |i| i.to_i }
    d = d.flatten
end

def timeCompare(line1, line2)
  t1 = line1.split("] ")[0][1..]
  t2 = line2.split("] ")[0][1..]

  d1 = timeToArray(t1)
  d2 = timeToArray(t2)

  for i in 0...5
    if (d1[i] <=> d2[i]) != 0
      return d1[i] <=> d2[i]
    end
  end

  return 0
end

def part1(input)

    input = input.sort { |a, b| timeCompare(a, b) }


    sleepTimes = {}
    guard = nil
    asleep = nil
    for line in input
      stamp, data = line.split("] ")
      stamp = stamp[1..]
      d = data.split(" ")
      if d[0] == "Guard"
        guard = d[1][1..].to_i
        next
      end
      if d[0] == "falls"
        asleep = timeToArray(stamp)[-1]
      end
      if d[0] == "wakes"
        if not sleepTimes[guard]
          sleepTimes[guard] = []
        end
        sleepTimes[guard].append([asleep, timeToArray(stamp)[-1]])
      end
    end

    guardChosen = sleepTimes.keys.max { |i, j| sleepTimes[i].map { |k| k[1] - k[0] }.sum <=> sleepTimes[j].map { |k| k[1] - k[0] }.sum }

    mostTimes = -1
    maxMinute = nil
    sleep = sleepTimes[guardChosen]
    for minute in 0...60
      times = 0
      for s in sleep
        if (s[0]...s[1]).include? minute
          times += 1
        end
      end
      if times > mostTimes
        mostTimes = times
        maxMinute = minute
      end
    end

    return guardChosen * maxMinute
end

def part2(input)
    input = input.sort { |a, b| timeCompare(a, b) }


    sleepTimes = {}
    guard = nil
    asleep = nil
    for line in input
      stamp, data = line.split("] ")
      stamp = stamp[1..]
      d = data.split(" ")
      if d[0] == "Guard"
        guard = d[1][1..].to_i
        next
      end
      if d[0] == "falls"
        asleep = timeToArray(stamp)[-1]
      end
      if d[0] == "wakes"
        if not sleepTimes[guard]
          sleepTimes[guard] = []
        end
        sleepTimes[guard].append([asleep, timeToArray(stamp)[-1]])
      end
    end

    mostTimes = -1
    worstGuard = nil
    maxMinute = nil

    for guardChosen in sleepTimes.keys
      sleep = sleepTimes[guardChosen]
      for minute in 0...60
        times = 0
        for s in sleep
          if (s[0]...s[1]).include? minute
            times += 1
          end
        end
        if times > mostTimes
          mostTimes = times
          maxMinute = minute
          worstGuard = guardChosen
        end
      end
    end

    return worstGuard * maxMinute
end

puts part1(data)
puts part2(data)
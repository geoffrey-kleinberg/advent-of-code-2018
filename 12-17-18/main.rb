require 'set'

day = "17"
file_name = "12-#{day}-18/sampleIn.txt"
file_name = "12-#{day}-18/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def waterBelow(source, claySquares, yMax, lines, hashtags)
    if source[1] > yMax
        return [false, false]
    end
    lines.add(source)
    below = [source[0], source[1] + 1]
    if not (claySquares.include? below or hashtags.include? below)
      waterBelow(below, claySquares, yMax, lines, hashtags)
    end
    left = [source[0] - 1, source[1]]
    if not (claySquares.include? left or hashtags.include? left or lines.include? left) and (claySquares.include? below or hashtags.include? below)
        leftClosed = waterBelow(left, claySquares, yMax, lines, hashtags)[0]
    end
    right = [source[0] + 1, source[1]]
    if not (claySquares.include? right or hashtags.include? right or lines.include? right) and (claySquares.include? below or hashtags.include? below)
        rightClosed = waterBelow(right, claySquares, yMax, lines, hashtags)[1]
    end

    answer = []
    if (leftClosed or claySquares.include? left)
      answer[0] = true
    end
    if (rightClosed or claySquares.include? right)
      answer[1] = true
    end

    if answer[0] and answer[1]
      toChange = source.clone
      while not claySquares.include? toChange
        lines.delete(toChange)
        hashtags.add(toChange.clone)
        toChange[0] += 1
      end
      toChange = source.clone
      while not claySquares.include? toChange
        lines.delete(toChange)
        hashtags.add(toChange.clone)
        toChange[0] -= 1
      end
    end
    
    return answer
end


# 31476 is wrong
# 31471 is right
def part1(input)
    claySquares = Set[]

    for line in input
        l1, l2 = line.split(", ")
        a1 = l1.split("=")[0]
        t1 = l1.split("=")[1].to_i
        t2 = l2.split("=")[1].split("..").map { |i| i.to_i }
        for i in t2[0]..t2[1]
            if a1 == "x"
                claySquares.add([t1, i])
            elsif a1 == "y"
                claySquares.add([i, t1])
            else
                raise "where"
            end
        end
    end
    yMin, yMax = claySquares.minmax { |i, j| i[1] <=> j[1] }.map { |i| i[1] }

    lines = Set[]
    hashtags = Set[]

    waterBelow([500, 0], claySquares, yMax, lines, hashtags)

    lines.keep_if { |i| i[1] >= yMin }
    hashtags.keep_if { |i| i[1] >= yMin }

    return (lines | hashtags).size
end

def part2(input)
    claySquares = Set[]

    for line in input
        l1, l2 = line.split(", ")
        a1 = l1.split("=")[0]
        t1 = l1.split("=")[1].to_i
        t2 = l2.split("=")[1].split("..").map { |i| i.to_i }
        for i in t2[0]..t2[1]
            if a1 == "x"
                claySquares.add([t1, i])
            elsif a1 == "y"
                claySquares.add([i, t1])
            else
                raise "where"
            end
        end
    end
    yMin, yMax = claySquares.minmax { |i, j| i[1] <=> j[1] }.map { |i| i[1] }

    lines = Set[]
    hashtags = Set[]

    waterBelow([500, 0], claySquares, yMax, lines, hashtags)

    lines.keep_if { |i| i[1] >= yMin }
    hashtags.keep_if { |i| i[1] >= yMin }

    return hashtags.size
end

puts part1(data)
puts part2(data)
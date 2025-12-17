require 'set'

day = "25"
file_name = "12-#{day}-18/sampleIn.txt"
file_name = "12-#{day}-18/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def manhattan(a1, a2)
    return (0...a1.length).map { |i| (a1[i] - a2[i]).abs }.sum
end

def part1(input)
    stars = input.map { |i| i.split(",").map { |j| j.to_i } }

    constellations = []

    added = Set[]
    unadded = (0...stars.length).to_a

    for s in 0...stars.length
        next if added.include? s

        queue = [s]
        constellations[constellations.length] = [s]
        unadded.delete(s)
        added.add(s)
        while queue.length > 0
            current = queue.pop

            uIdx = 0
            while uIdx < unadded.length
                u = unadded[uIdx]
                if manhattan(stars[u], stars[current]) <= 3
                    queue.append(u)
                    constellations[-1].append(u)
                    unadded.delete(u)
                    uIdx -= 1
                    added.add(u)
                end
                uIdx += 1
            end

        end
    end

    return constellations.size
end

def part2(input)
    return "free star!"
end

puts part1(data)
puts part2(data)

require 'set'

day = "08"
file_name = "12-#{day}-18/sampleIn.txt"
file_name = "12-#{day}-18/input.txt"

data = File.read(file_name).split("\n").map { |i| i.strip }

# returns [sum, length of node]
def getMetadataSum(children, metadata, remainder)
  if children == 0
    total = remainder[0...metadata].sum
    length = 2 + metadata
    return total, length
  end

  idx = 0
  total = 0
  for c in 0...children
    t, l = getMetadataSum(remainder[idx], remainder[idx + 1], remainder[(idx + 2)..])
    total += t
    idx += l
  end

  for m in 0...metadata
    total += remainder[idx + m]
  end

  return total, idx + metadata + 2
end

def part1(input)
    nums = input[0].split(" ").map { |i| i.to_i }

    total, length = getMetadataSum(nums[0], nums[1], nums[2..])
    return total
end

def getValue(children, metadata, remainder)
  if children == 0
    total = remainder[0...metadata].sum
    length = 2 + metadata
    return total, length
  end

  childValues = []
  idx = 0
  for c in 0...children
    t, l = getValue(remainder[idx], remainder[idx + 1], remainder[(idx + 2)..])
    childValues.append(t)
    idx += l
  end


  total = 0

  for m in 0...metadata
    add = childValues[remainder[idx + m] - 1]
    if add
      total += add
    end
  end

  return total, idx + metadata + 2
end

def part2(input)
    nums = input[0].split(" ").map { |i| i.to_i }

    value, length = getValue(nums[0], nums[1], nums[2..])
    return value
end

# puts part1(data)
puts part2(data)
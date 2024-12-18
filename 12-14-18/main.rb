require 'set'

day = "14"
file_name = "12-#{day}-18/sampleIn.txt"
# file_name = "12-#{day}-18/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def part1(input)
    numIters = 306281
    # numIters = 2018

    recipes = [3, 7]
    loc1 = 0
    loc2 = 1
    while recipes.length < numIters + 10
      newRecipe = recipes[loc1] + recipes[loc2]
      newTen = newRecipe / 10
      newOne = newRecipe % 10
      if newTen != 0
        recipes.append(newTen)
      end
      recipes.append(newOne)

      loc1 = (loc1 + recipes[loc1] + 1) % recipes.length
      loc2 = (loc2 + recipes[loc2] + 1) % recipes.length
    end

    return recipes.slice(numIters, 10).join
end

def part2(input)
    goalSequence = 306281.to_s.split("").map { |i| i.to_i }
    goalLen = goalSequence.length

    recipes = [3, 7]
    loc1 = 0
    loc2 = 1

    last6 = [nil, nil, nil, nil, 3, 7]

    while true
      newRecipe = recipes[loc1] + recipes[loc2]
      newTen = newRecipe / 10
      newOne = newRecipe % 10
      if newTen != 0
        recipes.append(newTen)
        last6 = last6.rotate
        last6[5] = newTen
        if last6 == goalSequence
          return recipes.length - goalLen
        end
      end
      recipes.append(newOne)
      last6 = last6.rotate
      last6[5] = newOne
      if last6 == goalSequence
        return recipes.length - goalLen
      end
      loc1 = (loc1 + recipes[loc1] + 1) % recipes.length
      loc2 = (loc2 + recipes[loc2] + 1) % recipes.length
    end
end

# puts part1(data)
puts part2(data)
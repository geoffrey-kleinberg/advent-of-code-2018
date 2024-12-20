require 'set'

day = "16"
file_name = "12-#{day}-18/sampleIn.txt"
file_name = "12-#{day}-18/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def behavesLike(before, instruction, after, opCode)
    a = instruction[1]
    b = instruction[2]
    c = instruction[3]
    if opCode == "addr"
        return (after[c] == before[a] + before[b])
    elsif opCode == "addi"
        return (after[c] == before[a] + b)
    elsif opCode == "mulr"
        return (after[c] == before[a] * before[b])
    elsif opCode == "muli"
        return (after[c] == before[a] * b)
    elsif opCode == "banr"
        return (after[c] == before[a] & before[b])
    elsif opCode == "bani"
        return (after[c] == before[a] & b)
    elsif opCode == "borr"
        return (after[c] == before[a] | before[b])
    elsif opCode == "bori"
        return (after[c] == before[a] | b)
    elsif opCode == "setr"
        return (after[c] == before[a])
    elsif opCode == "seti"
        return (after[c] == a)
    elsif opCode == "gtir"
        return (after[c] == ((a > before[b]) ? 1 : 0))
    elsif opCode == "gtri"
        return (after[c] == ((before[a] > b) ? 1 : 0))
    elsif opCode == "gtrr"
        return (after[c] == ((before[a] > before[b]) ? 1 : 0))
    elsif opCode == "eqir"
        return (after[c] == ((a == before[b]) ? 1 : 0))
    elsif opCode == "eqri"
        return (after[c] == ((before[a] == b) ? 1 : 0))
    elsif opCode == "eqrr"
        return (after[c] == ((before[a] == before[b]) ? 1 : 0))
    end

    raise 'escaped'

    return (before == after)
end

def part1(input)
    behaveLikeThree = 0
    lineNum = 0
    operations = [
        "addr",
        "addi",
        "mulr",
        "muli",
        "bani",
        "banr",
        "borr",
        "bori",
        "setr",
        "seti",
        "gtir",
        "gtri",
        "gtrr",
        "eqir",
        "eqri",
        "eqrr"
    ] 
    while true
      beforeLine = input[lineNum]
      if beforeLine == ""
        return behaveLikeThree
      end
      inst = input[lineNum + 1].split(" ").map { |i| i.to_i }
      afterLine = input[lineNum + 2]

      before = beforeLine.split("[")[1].chomp("]").split(", ").map { |i| i.to_i }
      after = afterLine.split("[")[1].chomp("]").split(", ").map { |i| i.to_i }

      count = 0

      for op in operations
        if behavesLike(before, inst, after, op)
            count += 1
        end
      end

      if count >= 3
        behaveLikeThree += 1
      end

      lineNum += 4
    end
end

def doInstruction(register, instruction)
    opCode = instruction[0]
    a = instruction[1]
    b = instruction[2]
    c = instruction[3]
    if opCode == "addr"
        register[c] = register[a] + register[b]
    elsif opCode == "addi"
        register[c] = register[a] + b
    elsif opCode == "mulr"
        register[c] = register[a] * register[b]
    elsif opCode == "muli"
        register[c] = register[a] * b
    elsif opCode == "banr"
        register[c] = register[a] & register[b]
    elsif opCode == "bani"
        register[c] = register[a] & b
    elsif opCode == "borr"
        register[c] = register[a] | register[b]
    elsif opCode == "bori"
        register[c] = register[a] | b
    elsif opCode == "setr"
        register[c] = register[a]
    elsif opCode == "seti"
        register[c] = a
    elsif opCode == "gtir"
        register[c] = ((a > register[b]) ? 1 : 0)
    elsif opCode == "gtri"
        register[c] = ((register[a] > b) ? 1 : 0)
    elsif opCode == "gtrr"
        register[c] = ((register[a] > register[b]) ? 1 : 0)
    elsif opCode == "eqir"
        register[c] = ((a == register[b]) ? 1 : 0)
    elsif opCode == "eqri"
        register[c] = ((register[a] == b) ? 1 : 0)
    elsif opCode == "eqrr"
        register[c] = ((register[a] == register[b]) ? 1 : 0)
    end
end

def part2(input)
    lineNum = 0
    operations = [
        "addr",
        "addi",
        "mulr",
        "muli",
        "bani",
        "banr",
        "borr",
        "bori",
        "setr",
        "seti",
        "gtir",
        "gtri",
        "gtrr",
        "eqir",
        "eqri",
        "eqrr"
    ] 
    possible = {}
    for i in 0...16
      possible[i] = operations.clone
    end
    while true
      beforeLine = input[lineNum]
      if beforeLine == ""
        break
      end
      inst = input[lineNum + 1].split(" ").map { |i| i.to_i }
      afterLine = input[lineNum + 2]

      before = beforeLine.split("[")[1].chomp("]").split(", ").map { |i| i.to_i }
      after = afterLine.split("[")[1].chomp("]").split(", ").map { |i| i.to_i }

      for op in possible[inst[0]]
        if not behavesLike(before, inst, after, op)
            possible[inst[0]].delete(op)
        end
      end

      lineNum += 4
    end

    confirmed = {}
    while confirmed.keys.length < 16
      for i in 0...16
        next if confirmed[i]
        if possible[i].length == 1
          confirmed[i] = possible[i][0]
          possible.delete(i)
          for j in possible.keys
            possible[j].delete(confirmed[i])
          end
        end
      end
    end

    lineNum += 2

    register = [0, 0, 0, 0]

    while lineNum < input.length
        inst = input[lineNum].split(" ").map { |i| i.to_i }
        inst[0] = confirmed[inst[0]]
        doInstruction(register, inst)
        lineNum += 1
    end

    return register[0]
end

# puts part1(data)
puts part2(data)
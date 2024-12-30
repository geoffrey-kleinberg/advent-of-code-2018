require 'set'

day = "19"
file_name = "12-#{day}-18/sampleIn.txt"
file_name = "12-#{day}-18/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

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

def part1(input)
    ptrRegister = input[0].split(" ")[1].to_i
    instructions = input[1..].map { |i| i.split(" ").map { |j| (/\d/.match? j) ? j.to_i : j } }

    register = [0, 0, 0, 0, 0, 0]
    while register[ptrRegister] < instructions.length
      doInstruction(register, instructions[register[ptrRegister]])
      register[ptrRegister] += 1
    end

    print register
    puts
    return register[0]
end

def part2(input)
    # get the sum of factors 10551343
    initial = 10551343
    sum = 0
    for i in 1..initial
      if initial % i == 0
        sum += i
      end
    end
    return sum
end

# sum of factors of 943
puts part1(data)
# sum of factors 10551343
puts part2(data)
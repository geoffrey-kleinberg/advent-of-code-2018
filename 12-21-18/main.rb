require 'set'

day = "21"
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
      if register[ptrRegister] == instructions.length - 3
        return register[5]
      end
      doInstruction(register, instructions[register[ptrRegister]])
      register[ptrRegister] += 1
    end
end

def part2(input)
    register = [0, 0, 0, 0, 0, 0]

    seen = Set[]
    prev = nil

    while true

      register[4] = register[5] | 65536
      register[5] = 13431073

      while true
        register[3] = register[4] & 255
        register[5] += register[3]

        register[5] &= 16777215
        register[5] *= 65899
        register[5] &= 16777215

        break if 256 > register[4]

        register[4] /= 256

      end

      if not seen.add? register[5]
        return prev
      end
      prev = register[5]
      
    end

end

puts part1(data)
puts part2(data)
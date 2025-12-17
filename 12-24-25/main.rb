require 'set'

day = "24"
file_name = "12-#{day}-18/sampleIn.txt"
file_name = "12-#{day}-18/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

class System

    attr_accessor :units, :hitPoints, :weaknesses, :immunities, :attackType, :damage, :initiative, :system

    def initialize(line, system)
        firstParts = line.split(" with ")
        @units = firstParts[0].split(" ")[0].to_i

        middleSection = firstParts[1].split(" (")
        @hitPoints = middleSection[0].split(" ")[0].to_i

        if middleSection[1]
            middleSection[1] = middleSection[1].chop
            parts = middleSection[1].split("; ")
            
            p1 = parts[0].split(" to ")
            if p1[0] == "weak"
                @weaknesses = p1[1].split(", ")
            elsif p1[0] == "immune"
                @immunities = p1[1].split(", ")
            else
                raise "shouldn't be here"
            end

            if parts[1]
                p2 = parts[1].split(" to ")
                if p2[0] == "weak"
                    @weaknesses = p2[1].split(", ")
                elsif p2[0] == "immune"
                    @immunities = p2[1].split(", ")
                else
                    raise "shouldn't be here"
                end
            else
                if p1[0] == "weak"
                    @immunities = []
                else
                    @weaknesses = []
                end
            end

        else
            @weaknesses = []
            @immunities = []
        end


        lastPart = firstParts[2].split(" ")

        @damage = lastPart[4].to_i
        @attackType = lastPart[5]
        @initiative = lastPart[-1].to_i

        @system = system

    end

    def to_s
        return "#{@system} team with #{@units} units at #{@hitPoints} HP dealing #{@damage} #{@attackType} damage with initiative #{@initiative}.\nWeak to #{@weaknesses}, immune to #{@immunities}.\n"
    end

    def effectivePower
        @damage * @units
    end

    def potentialDamage(other)

        if not other.immunities
            puts other
        end
        if other.weaknesses.include? @attackType
            return self.effectivePower * 2
        elsif other.immunities.include? @attackType
            return 0
        else
            return self.effectivePower
        end
    end

end

def getTargetChoice(sys, possible, chosen)
    notChosen = []
    for opt in possible
        if not chosen.include? opt
            notChosen.append(opt)
        end
    end

    if notChosen.map { |i| sys.potentialDamage(i) }.all? { |i| i == 0 }
        return nil
    end

    sorted = notChosen.sort { |a, b| (a.initiative <=> b.initiative) + 2 * (a.effectivePower <=> b.effectivePower) + 4 * (sys.potentialDamage(a) <=> sys.potentialDamage(b)) }
    return sorted[-1]
end

def iterate(immuneSystem, infection)
    # target selection phase

    chosen = Set[]
    choices = {}

    selectingOrder = (immuneSystem + infection).sort { |a, b|  (a.initiative <=> b.initiative) + 2 * (a.effectivePower <=> b.effectivePower) }.reverse

    for sys in selectingOrder

        if sys.system == "immune"
            choice = getTargetChoice(sys, infection, chosen)
        else
            choice = getTargetChoice(sys, immuneSystem, chosen)
        end

        if choice
            choices[sys] = choice
            chosen.add(choice)
        end

    end

    # attacking phase

    attackOrder = (immuneSystem + infection).sort { |a, b| a.initiative <=> b.initiative }.reverse

    oneAttackCompleted = false

    for sys in attackOrder

        next if sys.units <= 0

        attacked = choices[sys]

        next if not attacked

        oneAttackCompleted = true

        attacked.units -= sys.potentialDamage(attacked) / attacked.hitPoints
    end

    immuneSystem.delete_if { |i| i.units <= 0 }
    infection.delete_if { |i| i.units <= 0 }
end

def part1(input)

    immuneSystem = []
    infection = []

    gapIndex = input.index("")

    for line in input[1...gapIndex]
        immuneSystem.append(System.new(line, 'immune'))
    end

    for line in input[(gapIndex + 2)..-1]
        infection.append(System.new(line, 'infection'))
    end

    while immuneSystem.length > 0 and infection.length > 0
        iterate(immuneSystem, infection)
    end

    return immuneSystem.map { |i| i.units }.sum + infection.map { |i| i.units }.sum
end

def getNextBoost(lower, upper, foundUpper)
    foundUpper ? ((lower + upper) / 2) : (lower * 2)
end

def part2(input)
    immuneSystem = []
    infection = []

    gapIndex = input.index("")

    boost = 1

    foundUpper = false
    upper = boost
    lower = boost

    remaining = {}

    while true
        puts "Trying boost of #{boost}"

        immuneSystem = []
        infection = []

        for line in input[1...gapIndex]
            immuneSystem.append(System.new(line, 'immune'))
        end

        for line in input[(gapIndex + 2)..-1]
            infection.append(System.new(line, 'infection'))
        end

        immuneSystem.each { |i| i.damage += boost }

        unitsPrevious = immuneSystem.map { |i| i.units }.sum + infection.map { |i| i.units }.sum
        while immuneSystem.length > 0 and infection.length > 0
            iterate(immuneSystem, infection)

            units = immuneSystem.map { |i| i.units }.sum + infection.map { |i| i.units }.sum
            if units == unitsPrevious
                puts "deadlock"
                break
            end
            unitsPrevious = units
        end

        if infection.length == 0
            upper = boost
            foundUpper = true
            remaining[boost] = immuneSystem.map { |i| i.units }.sum
            puts "successful!"
        else
            lower = boost
            puts "unsuccessful"
        end

        if lower == upper - 1
            return remaining[upper]
        end

        boost = getNextBoost(lower, upper, foundUpper)
    end
end

puts part1(data)
puts part2(data)

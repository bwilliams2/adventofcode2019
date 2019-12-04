using DelimitedFiles
program = readdlm("data/day2input.txt", ',', Int, '\n')
program[2] = 12
program[3] = 2
function ExecuteProgram(prog)
    global pos = 1
    while true
        global pos
        if prog[pos] == 99
            break
        end
        var_1 = prog[pos + 1] + 1
        var_2 = prog[pos + 2] + 1
        out_pos = prog[pos + 3] + 1
        if prog[pos] == 1
            prog[out_pos] = prog[var_1] + prog[var_2]
        elseif prog[pos] == 2
            prog[out_pos] = prog[var_1] * prog[var_2]
        end
        pos += 4
    end
end
ExecuteProgram(program)
print("Value at position 0 is ", program[1])

using IterTools
global noun = 0
global verb = 0
for p in Iterators.product(0:99, 0:99)
    global noun
    global verb
    program = readdlm("data/day2input.txt", ',', Int, '\n')
    program[2] = p[1]
    program[3] = p[2]
    ExecuteProgram(program)
    if program[1] == 19690720
        print("in")
        noun = p[1]
        verb = p[2]
        break
    end
end
print("\n")
print("100 * noun + verb = ", 100 * noun + verb)

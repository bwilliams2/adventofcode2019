using DelimitedFiles

function Input()
    print("Input value: ")
    d = readline()
    return d
end

function ProcessJump(pos, prog)
    code = reverse(digits(prog[pos]))
    zero_len = 4 - length(code)
    code = vcat(zeros(Int64, zero_len), code)
    values = []
    if code[2] == 1
        param = prog[pos + 1]
    else
        param = prog[prog[pos + 1] + 1]
    end
    if (code[length(code)] == 5 && param == 0) || (code[length(code)] == 6 && param != 0)
        return pos + 3
    end
    if code[1] == 1
        return prog[pos + 2] + 1
    else
        return prog[prog[pos + 2] + 1] + 1
    end
end


function ProcessCode(pos, prog)
    code = reverse(digits(prog[pos]))
    zero_len = 5 - length(code)
    code = vcat(zeros(Int64, zero_len), code)
    values = []
    for (n, i) in enumerate([code[3], code[2]])
        if i == 0
            push!(values, prog[prog[pos + n] + 1])
        else
            push!(values, prog[pos + n])
        end
    end
    if code[length(code)] == 1
        out = reduce(+, values)
    elseif code[length(code)] == 2
        out = reduce(*, values)
    elseif code[length(code)] == 7
        if values[1] < values[2]
            out = 1
        else
            out = 0
        end
    elseif code[length(code)] == 8
        if values[1] == values[2]
            out = 1
        else
            out = 0
        end
    end
    if code[1] == 0
        prog[prog[pos + 3] + 1] = out
    else
        prog[pos + 3] = out
    end
end

function ExecuteProgram(prog)
    global pos = 1
    global output = []
    while true
        global pos
        if prog[pos] == 99
            break
        end
        codes = reverse(digits(prog[pos]))
        opcode = codes[length(codes)]

        if opcode == 3
            d = parse(Int64, Input())
            if length(codes) > 1 && codes[1] == 1
                prog[pos+1] = d
            else
                prog[prog[pos + 1] + 1] = d
            end
        elseif opcode == 4
            if length(codes) > 1 && codes[1] == 1
                append!(output, prog[pos+1])
            else
                append!(output, prog[prog[pos + 1] + 1])
            end
        elseif opcode in [5, 6]
            pos = ProcessJump(pos, prog)
        else
            ProcessCode(pos, prog)
        end
        if opcode in [1,2, 7, 8]
            pos += 4
        elseif opcode in [3, 4]
            pos += 2
        end
    end
end

function main()
    global output = []
    program = readdlm("data/day5input.txt", ',', Int, '\n')
    ExecuteProgram(program)
    return output
end

# print("Value at position 0 is ", program[1])

# using IterTools
# global noun = 0
# global verb = 0
# for p in Iterators.product(0:99, 0:99)
#     global noun
#     global verb
#     program = readdlm("data/day2input.txt", ',', Int, '\n')
#     program[2] = p[1]
#     program[3] = p[2]
#     ExecuteProgram(program)
#     if program[1] == 19690720
#         print("in")
#         noun = p[1]
#         verb = p[2]
#         break
#     end
# end
# print("\n")
# print("100 * noun + verb = ", 100 * noun + verb)

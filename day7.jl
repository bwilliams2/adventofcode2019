using DelimitedFiles
using InvertedIndices
using Combinatorics
include("day5.jl")

function ExecuteProgram(num, progs)
    this_prog = progs[num]
    global input_n = 1
    while true
        if this_prog.break_status
            break
        end
        if this_prog.code[this_prog.pos] == 99
            this_prog.break_status = true
            ExecuteProgram(this_prog.next, progs)
            break
        end
        codes = reverse(digits(this_prog.code[this_prog.pos]))
        opcode = codes[length(codes)]
        if opcode == 3
            # d = parse(Int64, Input())
            if !this_prog.setting_read
                d = this_prog.setting
                this_prog.setting_read = true
            else
                if progs[this_prog.prev].output === nothing
                    ExecuteProgram(this_prog.next, progs)
                    if progs[this_prog.next].break_status
                        this_prog.break_status = true
                        break
                    end
                end
                d = progs[this_prog.prev].output
                progs[this_prog.prev].output = nothing
            end
            
            if length(codes) > 1 && codes[1] == 1
                this_prog.code[this_prog.pos + 1] = d
            else
                this_prog.code[this_prog.code[this_prog.pos + 1] + 1] = d
            end
            input_n += 1
        elseif opcode == 4
            if length(codes) > 1 && codes[1] == 1
                this_prog.output = this_prog.code[this_prog.pos + 1]
            else
                this_prog.output = this_prog.code[this_prog.code[this_prog.pos + 1] + 1]
            end
        elseif opcode in [5, 6]
            this_prog.pos = ProcessJump(this_prog.pos, this_prog.code)
        else
            ProcessCode(this_prog.pos, this_prog.code)
        end
        if opcode in [1, 2, 7, 8]
            this_prog.pos += 4
        elseif opcode in [3, 4]
            this_prog.pos += 2
        end
    end
end


mutable struct Program
    next::Int
    prev::Int
    pos::Int
    code::Any
    setting::Any
    output::Any
    input::Any
    setting_read::Any
    break_status::Any
end


function InputOutput(amp_settings)
    amp_programs = [program = readdlm("data/day7input.txt", ',', Int, '\n') for n in 1:5]
    progs = [Program(0, 0, 1, code, amp_settings[n], 0, 0, false, false) for (n, code) in enumerate(amp_programs)]    
    for n in 1:5
        if n == 1
            progs[n].prev = 5
        else
            progs[n].prev = n - 1
        end
        if n == 5
            progs[n].next = 1
        else
            progs[n].output = nothing
            progs[n].next = n + 1
        end
    end
    ExecuteProgram(1, progs)
    return progs[length(progs)].output
end


function FindThruster(rang)
    inputs = collect(Combinatorics.permutations(rang))

    thruster = []
    for amp_inputs in inputs
        d = InputOutput(amp_inputs)
        push!(thruster, d[length(d)])
    end
    return maximum(thruster)
end

println("Part 1: Highest signal is ", FindThruster(0:4))

println("Part 2: Highest signal is ", FindThruster(5:9))

using CSV
using InvertedIndices

wire1 = CSV.read("data/day3input.txt"; limit=1, header=0)
wire2 = CSV.read("data/day3input.txt"; skipto=2, limit=1, header=0)
function calcPos(path)
    total_steps = [0]
    pos = [[0, 0]]
    for (i, route) in enumerate(path)
        steps = parse(Int64, match(r"\d+", route).match)
        vert = 0
        horz = 0
        if occursin("R", route)
            horz = 1
        elseif occursin("L", route)
            horz = -1
        elseif occursin("U", route)
            vert = 1
        elseif occursin("D", route)
            vert = -1
        end
        for n in 1:steps
            append!(pos, [[pos[length(pos)][1] + horz, pos[length(pos)][2] + vert]])
        end
    end
    return pos
end
wire1_pos = calcPos(Matrix(wire1))
wire2_pos = calcPos(Matrix(wire2))

int_idx = findall(in(wire1_pos), wire2_pos)
distances = (x -> abs(x[1]) + abs(x[2])).(wire2_pos)[int_idx]
min_dis = sort(distances[distances .!= 0])[1]
print("The min distance is ", min_dis)
print("\n")

steps = []
for wire2_steps in int_idx
    wire1_steps = findfirst((x -> x == wire2_pos[wire2_steps]).(wire1_pos))
    append!(steps, (wire1_steps + wire2_steps))
end
steps = steps .- 2
min_steps = minimum(steps[steps .!= 0])
print("Minimum steps to intersection is ", min_steps)


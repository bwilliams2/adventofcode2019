
using DelimitedFiles

mutable struct Planet
    orbits::Array{String}
    orbited::Array{String}
    indirects::Int64
    directs::Int64
end

function CreateOrbits()
    orbits = readdlm("data/day6input.txt", ')', String, '\n')
    primary = Dict()
    for orbit_pair in eachrow(orbits)
        if orbit_pair[1] in keys(primary)
            push!(primary[orbit_pair[1]].orbited, orbit_pair[2])
        else
            primary[orbit_pair[1]] = Planet([], [orbit_pair[2]], 0, 0)
        end
        if orbit_pair[2] in keys(primary)
            push!(primary[orbit_pair[2]].orbits, orbit_pair[1])
        else
            primary[orbit_pair[2]] = Planet([orbit_pair[1]], [], 0, 0)
        end
    end
    return primary
end

function FindIndirect(primary, parent, indirects)
    i = 1
    orbits = primary[parent].orbits
    if length(orbits) == 0
        return indirects
    end
    while i <= length(orbits)
        indirects += 1
        indirects = FindIndirect(primary, orbits[i], indirects)
        i += 1
    end
    return indirects
end

function CountOrbits(primary) 
    for plan in keys(primary)
        primary[plan].directs = length(primary[plan].orbits)
        primary[plan].indirects = FindIndirect(primary, plan, 0) - length(primary[plan].orbits)
    end
end

function Part1()
    primary = CreateOrbits()
    CountOrbits(primary)
    total_directs = reduce(+, map((x -> x.directs), values(primary)))
    total_indirects = reduce(+, map((x -> x.indirects), values(primary)))
    println("Total orbits = ", total_directs + total_indirects)
    return primary
end

function FindPath(p, plan, path, all_paths)
    i = 1
    orbits = p[plan].orbits
    if length(orbits) > 1
        println("greater")
    end
    if length(orbits) == 0
        print("in\n")
        append!(all_paths, path)
    end
    while i <= length(orbits)
        push!(path, orbits[i])
        new_path = deepcopy(path)
        FindPath(p, orbits[i], new_path, all_paths)
        i += 1
    end
end
        
    

p = Part1()

SANPaths = []
FindPath(p, p["SAN"].orbits[1], [], SANPaths)
YOUPaths = []
FindPath(p, "YOU", [], YOUPaths)
you_inter = findall(in(SANPaths), YOUPaths)[1]
san_inter = findfirst(SANPaths .== YOUPaths[you_inter])
path = [YOUPaths[1:you_inter - 1]; SANPaths[1:san_inter]]
length(path)



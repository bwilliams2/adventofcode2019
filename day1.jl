using DelimitedFiles
weights = readdlm("data/day1input.txt", '\t', Int, '\n')

fuel = (x -> floor(x/3) - 2).(weights) 
println("The fuel required for the modules is ", sum(fuel))

function fuelcalc(x, currSum)
    req = floor(x / 3) - 2
    if req < 0
        return currSum
    else
        return fuelcalc(req, currSum + req)
    end
end

println("The fuel required including the fuel itself is ", sum((x -> fuelcalc(x, 0)).(weights)))
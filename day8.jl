using DelimitedFiles
data = [parse(Int, ss) for ss in split(chomp(read("data/day8input.txt", String)), "")]
image = reshape(data, 25, 6, :)
zeros = dropdims(sum(image .== 0, dims=[1,2]); dims=1)
layer = image[:, :, findmin(zeros)[2][2]]
ones = count(layer .== 1)
twos = count(layer .== 2)
onestows = ones * twos

function FindColor(pixel) 
    first_white = findfirst(pixel .== 1)
    first_black = findfirst(pixel .== 0)
    if first_black === nothing
        return 1
    elseif first_white === nothing
        return 0
    end
    if first_white < first_black
        return 1
    else
        return 0
    end
end

pic = Array{Int, 2}(undef, 25, 6)

for i in 1:25
    for j in 1:6
        pic[i, j] = FindColor(image[i, j, :])
    end
end
pic
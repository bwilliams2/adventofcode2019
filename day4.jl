using InvertedIndices

valid_codes = []
code_range = collect(165432:707912)
for code in code_range
    values = reverse(digits(code))
    shifted = circshift(values, 1)
    consect = any(values .== shifted)
    decrease = all((values - shifted)[Not(1)] .>= 0)
    if consect && decrease
        append!(valid_codes, code)
    end
end
print("Number of valid codes is ", length(valid_codes))
print("\n")

valid_valid_codes = []
for code in valid_codes
    values = reverse(digits(code))
    shifted = circshift(values, 1)
    rev_shifted = circshift(values, -1)
    f = findall((x -> x == 0), values - shifted)
    r = findall((x -> x == 0), values - rev_shifted)
    repeat_idx = unique(sort(reduce(vcat, [r, f])))
    consect_nums = unique(values[repeat_idx])
    if length(repeat_idx) == 2
        append!(valid_valid_codes, code)
    elseif length(consect_nums) > 1
        for num in consect_nums
            if count(values[repeat_idx] .== num) == 2
                append!(valid_valid_codes, code)
                break
            end
        end
    end
end
print("Number of really valid codes is ", valid_valid_codes)

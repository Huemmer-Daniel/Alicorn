module TestingTools

using Random

# function generateInvalidString(validStrings::Array{String})
#     isValid = true
#     randomString = ""
#     while isValid
#         randomString = Random.randstring(12)
#         isValid = Utils.isElementOf(randomString,validStrings)
#     end
#     return randomString
# end

function getInfiniteNumbers()
    return [ Inf, -Inf, Inf64, Inf32, Inf16, NaN, NaN64, NaN32, NaN16 ]
end

function getShowString(object)
    io = IOBuffer()
    show(io, object)
    generatedString = String(take!(io))
    return generatedString
end

end # module

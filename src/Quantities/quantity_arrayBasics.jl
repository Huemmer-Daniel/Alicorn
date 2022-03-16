Base.eltype(sqArray::SimpleQuantityArray{T}) where T = SimpleQuantity{T}
Base.eltype(sqArray::QuantityArray{T}) where T = Quantity{T}

## TODO below

Base.circshift(sqArray::SimpleQuantityArray, shifts::Real) = circshift(sqArray.value, shifts) * sqArray.unit
Base.circshift(sqArray::SimpleQuantityArray, shifts::Base.DimsInteger) = circshift(sqArray.value, shifts) * sqArray.unit
Base.circshift(sqArray::SimpleQuantityArray, shifts) = circshift(sqArray.value, shifts) * sqArray.unit

Base.deleteat!(sqArray::SimpleQuantityArray, inds) = deleteat!(sqArray.value, inds)


# method documented in Base
function Base.findmax(sqArray::SimpleQuantityArray; dims=:)
    unit = sqArray.unit
    array = sqArray.value

    (maxVal, maxIndex) = findmax(array, dims=dims)

    return (maxVal * unit, maxIndex)
end

# method documented in Base
function Base.findmin(sqArray::SimpleQuantityArray; dims=:)
    unit = sqArray.unit
    array = sqArray.value

    (minVal, minIndex) = findmin(array, dims=dims)

    return (minVal * unit, minIndex)
end

function Base.transpose(sqArray::SimpleQuantityArray)
    unit = sqArray.unit
    value = transpose(sqArray.value)
    return SimpleQuantityArray(value, unit)
end

function Base.repeat(sqArray::SimpleQuantityArray; inner=nothing, outer=nothing)
    unit = sqArray.unit
    array = sqArray.value

    repeatedArray = repeat(array; inner=inner, outer=outer)

    return repeatedArray * unit
end

function Base.repeat(sqArray::SimpleQuantityArray, counts...)
    return repeat(sqArray, outer=counts)
end

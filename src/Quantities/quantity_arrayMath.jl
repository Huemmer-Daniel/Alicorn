Base.circshift(sqArray::SimpleQuantityArray, shifts::Real) = circshift(sqArray.value, shifts) * sqArray.unit
Base.circshift(sqArray::SimpleQuantityArray, shifts::Base.DimsInteger) = circshift(sqArray.value, shifts) * sqArray.unit
Base.circshift(sqArray::SimpleQuantityArray, shifts) = circshift(sqArray.value, shifts) * sqArray.unit

function Base.transpose(sqArray::SimpleQuantityArray)
    unit = sqArray.unit
    value = transpose(sqArray.value)
    return SimpleQuantityArray(value, unit)
end

function Base.findmax(sqArray::SimpleQuantityArray; dims=:)
    unit = sqArray.unit
    array = sqArray.value

    (maxVal, maxIndex) = findmax(array, dims=dims)

    return (maxVal * unit, maxIndex)
end

function Base.findmin(sqArray::SimpleQuantityArray; dims=:)
    unit = sqArray.unit
    array = sqArray.value

    (minVal, minIndex) = findmin(array, dims=dims)

    return (minVal * unit, minIndex)
end

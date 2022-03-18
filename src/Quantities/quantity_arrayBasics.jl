## eltype
Base.eltype(sqArray::SimpleQuantityArray{T}) where T = SimpleQuantity{T}
Base.eltype(sqArray::QuantityArray{T}) where T = Quantity{T}

## deleteat!
function Base.deleteat!(sqArray::SimpleQuantityVector, inds)
    deleteat!(sqArray.value, inds)
    return sqArray
end

function Base.deleteat!(qArray::QuantityVector, inds)
    deleteat!(qArray.value, inds)
    return qArray
end

## repeat
function Base.repeat(sqArray::SimpleQuantityArray; inner=nothing, outer=nothing)
    array = sqArray.value
    repeatedArray = repeat(array; inner=inner, outer=outer)
    return SimpleQuantityArray( repeatedArray, sqArray.unit )
end

function Base.repeat(sqArray::SimpleQuantityArray, counts...)
    return repeat(sqArray, outer=counts)
end

function Base.repeat(qArray::QuantityArray; inner=nothing, outer=nothing)
    array = qArray.value
    repeatedArray = repeat(array; inner=inner, outer=outer)
    return QuantityArray(repeatedArray, qArray.dimension, qArray.internalUnits )
end

function Base.repeat(qArray::QuantityArray, counts...)
    return repeat(qArray, outer=counts)
end

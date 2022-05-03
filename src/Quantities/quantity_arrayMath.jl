## circshift
Base.circshift(sqArray::SimpleQuantityArray, shifts::Real) =
    SimpleQuantityArray(circshift(sqArray.value, shifts), sqArray.unit)
Base.circshift(sqArray::SimpleQuantityArray, shifts::Base.DimsInteger) =
    SimpleQuantityArray(circshift(sqArray.value, shifts), sqArray.unit)
Base.circshift(sqArray::SimpleQuantityArray, shifts) =
    SimpleQuantityArray(circshift(sqArray.value, shifts), sqArray.unit)

Base.circshift(qArray::QuantityArray, shifts::Real) =
    QuantityArray(circshift(qArray.value, shifts), qArray.dimension, qArray.internalUnits)
Base.circshift(qArray::QuantityArray, shifts::Base.DimsInteger) =
    QuantityArray(circshift(qArray.value, shifts), qArray.dimension, qArray.internalUnits)
Base.circshift(qArray::QuantityArray, shifts) =
    QuantityArray(circshift(qArray.value, shifts), qArray.dimension, qArray.internalUnits)


## transpose
Base.transpose(sqArray::SimpleQuantityArray) = SimpleQuantityArray(transpose(sqArray.value), sqArray.unit)

Base.transpose(qArray::QuantityArray) = QuantityArray(transpose(qArray.value), qArray.dimension, qArray.internalUnits)


## findmax
function Base.findmax(sqArray::SimpleQuantityArray; dims=:)
    (maxVal, maxIndex) = findmax(sqArray.value, dims=dims)
    return ( SimpleQuantity(maxVal, sqArray.unit), maxIndex )
end

function Base.findmax(qArray::QuantityArray; dims=:)
    (maxVal, maxIndex) = findmax(qArray.value, dims=dims)
    return ( Quantity(maxVal, qArray.dimension, qArray.internalUnits), maxIndex )
end


## findmin
function Base.findmin(sqArray::SimpleQuantityArray; dims=:)
    (minVal, minIndex) = findmin(sqArray.value, dims=dims)
    return ( SimpleQuantity(minVal, sqArray.unit), minIndex )
end

function Base.findmin(qArray::QuantityArray; dims=:)
    (minVal, minIndex) = findmin(qArray.value, dims=dims)
    return ( Quantity(minVal, qArray.dimension, qArray.internalUnits), minIndex )
end

## ## Methods implementing the interface of AbstractArray

Base.size(qArray::Union{SimpleQuantityArray, QuantityArray}) = size(qArray.value)

Base.IndexStyle(::Type{<:SimpleQuantityArray}) = IndexLinear()
Base.IndexStyle(::Type{<:QuantityArray}) = IndexLinear()

# define getindex twice -- once with a single argument, once as varargs --
# to avoid unintended splatting if inds is itself an iterable collection
Base.getindex(sqArray::SimpleQuantityArray, inds) = getindex(sqArray.value, inds) * sqArray.unit
Base.getindex(sqArray::SimpleQuantityArray, inds...) = getindex(sqArray.value, inds...) * sqArray.unit

function Base.getindex(qArray::QuantityArray, inds)
    subarray = getindex(qArray.value, inds)
    if length(subarray) == 1
        return Quantity(subarray, qArray.dimension, qArray.internalUnits)
    else
        return QuantityArray(subarray, qArray.dimension, qArray.internalUnits)
    end
end

function Base.getindex(qArray::QuantityArray, inds...)
    subarray = getindex(qArray.value, inds...)
    if length(subarray) == 1
        return Quantity(subarray, qArray.dimension, qArray.internalUnits)
    else
        return QuantityArray(subarray, qArray.dimension, qArray.internalUnits)
    end
end

# define setindex! twice -- once with a single argument, once as varargs --
# to avoid unintended splatting if inds is itself an iterable collection
function Base.setindex!(sqArray::SimpleQuantityArray, sqSubarray::SimpleQuantityType, inds)
    sqSubarray = inUnitsOf(sqSubarray, sqArray.unit)
    resultingArray = setindex!(sqArray.value, sqSubarray.value, inds)
    return resultingArray * sqArray.unit
end

function Base.setindex!(sqArray::SimpleQuantityArray, sqSubarray::SimpleQuantityType, inds...)
    sqSubarray = inUnitsOf(sqSubarray, sqArray.unit)
    resultingArray = setindex!(sqArray.value, sqSubarray.value, inds...)
    return resultingArray * sqArray.unit
end

function Base.setindex!(qArray::QuantityArray, qSubarray::QuantityType, inds)
    _setindex!_verifySameDimension(qArray, qSubarray)
    qSubarray = inInternalUnitsOf(qSubarray, qArray.internalUnits)
    resultingArray = setindex!(qArray.value, qSubarray.value, inds)
    return QuantityArray(resultingArray, qArray.dimension, qArray.internalUnits)
end

function Base.setindex!(qArray::QuantityArray, qSubarray::QuantityType, inds...)
    _setindex!_verifySameDimension(qArray, qSubarray)
    qSubarray = inInternalUnitsOf(qSubarray, qArray.internalUnits)
    resultingArray = setindex!(qArray.value, qSubarray.value, inds...)
    return QuantityArray(resultingArray, qArray.dimension, qArray.internalUnits)
end

function _setindex!_verifySameDimension(qArray::QuantityType, qSubarray::QuantityType)
    if qArray.dimension != qSubarray.dimension
        error = Exceptions.DimensionMismatchError("cannot assign subarray: physical dimensions are not equal")
        throw(error)
    end
end

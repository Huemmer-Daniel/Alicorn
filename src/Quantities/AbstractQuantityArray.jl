export AbstractQuantityArray
"""
    AbstractQuantity{T,N} <: AbstractArray{T,N}

Abstract supertype for all types that represent a physical quantity array.

Currently the only concrete subtype of `AbstractQuantityArray` is [`AbstractQuantityArray`](@ref).
"""
abstract type AbstractQuantityArray{T,N} <: AbstractArray{T,N} end

## ## Interface
# the following functions need to be extended for concrete implementations of
# AbstractQuantity

## 1. Unit conversion

export inUnitsOf
"""
    inUnitsOf(qArray::AbstractQuantityArray, targetUnit::AbstractUnit)::SimpleQuantityArray

Express `quantity` as an object of type `SimpleQuantity` in terms of the unit specified by `targetUnit`.
"""
function inUnitsOf(qArray::AbstractQuantityArray, targetUnit::AbstractUnit)::SimpleQuantityArray
    subtype = typeof(qArray)
    error("missing specialization of inUnitsOf(::AbstractQuantityArray, ::AbstractUnit) for subtype $subtype")
end

## TODO below
"""
    Base.transpose(quantity::AbstractQuantityArray)

Transpose `quantity`.
"""
function Base.transpose(quantity::AbstractQuantityArray)
    subtype = typeof(quantity)
    error("subtype $subtype of AbstractQuantityArray misses an implementation of the transpose function")
end

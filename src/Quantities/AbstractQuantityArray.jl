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

Express `qArray` as an object of type `SimpleQuantityArray` in terms of the unit specified by `targetUnit`.
"""
function inUnitsOf(qArray::AbstractQuantityArray, targetUnit::AbstractUnit)::SimpleQuantityArray
    subtype = typeof(qArray)
    error("missing specialization of inUnitsOf(::AbstractQuantityArray, ::AbstractUnit) for subtype $subtype")
end

export inBasicSIUnits
"""
    inBasicSIUnits(qArray::AbstractQuantity)::SimpleQuantityArray

Express `qArray` as an object of type `SimpleQuantityArray` using the seven basic SI units.
"""
function inBasicSIUnits(qArray::AbstractQuantityArray)::SimpleQuantityArray
    subtype = typeof(qArray)
    error("missing specialization of inBasicSIUnits(::AbstractQuantityArray) for subtype $subtype")
end

"""
    Base.:*(qArray::AbstractQuantityArray, unit::AbstractUnit)
    Base.:*(unit::AbstractUnit, qArray::AbstractQuantityArray)

Modify the unit of `qArray` by multiplying it with `unit`.
"""
function Base.:*(qArray::AbstractQuantityArray, unit::AbstractUnit)
    subtype = typeof(qArray)
    error("missing specialization of Base.:*(::AbstractQuantityArray, ::AbstractUnit) for subtype $subtype")
end

function Base.:*(unit::AbstractUnit, qArray::AbstractQuantityArray)
    subtype = typeof(qArray)
    error("missing specialization of Base.:*(::AbstractUnit, ::AbstractQuantityArray) for subtype $subtype")
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

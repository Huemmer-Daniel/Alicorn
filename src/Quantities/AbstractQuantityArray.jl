export AbstractQuantityArray
abstract type AbstractQuantityArray{T,N} <: AbstractArray{T,N} end

"""
    Base.transpose(quantity::AbstractQuantityArray)

Transpose `quantity`.
"""
function Base.transpose(quantity::AbstractQuantityArray)
    subtype = typeof(quantity)
    error("subtype $subtype of AbstractQuantityArray misses an implementation of the transpose function")
end

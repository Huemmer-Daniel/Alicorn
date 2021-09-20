export QuantityArray
@doc raw"""
    Quantity{T} <: AbstractQuantity{T}

A physical quantity consisting of ...
TODO
"""
mutable struct QuantityArray{T<:Number,N} <: AbstractQuantityArray{T,N}
    value::Array{T,N}
    dimension::Dimension
    internalUnits::InternalUnits
end

export QuantityVector
QuantityVector{T} = QuantityArray{T,1}

export QuantityMatrix
QuantityMatrix{T} = QuantityArray{T,2}

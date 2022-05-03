"""
    AbstractQuantity{T<:Number}

Abstract supertype for all quantities that have a scalar value (number) of type
`T`.
"""
abstract type AbstractQuantity{T<:Number} end

"""
    ScalarQuantity{T}

Type union representing a scalar (number) of type `T`, with or without a unit.

Alias for `Union{T, AbstractQuantity{T}} where T<:Number`.
"""
ScalarQuantity{T} = Union{T, AbstractQuantity{T}} where T<:Number

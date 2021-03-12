export Quantity
@doc raw"""
    Quantity{T} <: AbstractQuantity

A physical quantity consisting of... TODO
"""
mutable struct Quantity{T} <: AbstractQuantity
    value::T
    dimension::Dimension
    internalUnits::InternalUnits
end

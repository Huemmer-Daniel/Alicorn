"""
    AbstractUnitElement

Abstract supertype for all types used in constructing a physical unit.

All [`AbstractUnit`](@ref) types are subtypes of `AbstractUnitElement`. The only concrete subtype of `AbstractUnitElement` is [`UnitPrefix`](@ref).
"""
abstract type AbstractUnitElement end

export AbstractUnitElement
"""
    AbstractUnitElement

Abstract supertype for all types used in constructing a physical unit.

All `AbstractUnit` types are subtypes of `AbstractUnitElement`. The only other subtype of `AbstractUnitElement` is `UnitPrefix`.
"""
abstract type AbstractUnitElement end

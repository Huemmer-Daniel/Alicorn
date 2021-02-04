export AbstractUnit
"""
    AbstractUnit <: AbstractUnitElement

Abstract supertype for all types that can represent a physical unit.

The concrete subtypes of `AbstractUnit` are [`BaseUnit`](@ref), [`UnitFactor`](@ref), and [`Unit`](@ref).
"""
abstract type AbstractUnit <: AbstractUnitElement end

## 1. Generic functions
# these functions need to work for all implementations of AbstractUnit

"""
    Base.:*(abstractUnit1::AbstractUnit, abstractUnit2::AbstractUnit)

Multiply two objects of type `AbstractUnit` and return the result as a `Unit`.

The method ultimately calls [`Base.:*(::Unit, ::Unit)`](@ref).

# Examples
```jldoctest
julia> kilogram = Alicorn.kilogram
UnitFactor kg
julia> kilogram * kilogram
Unit kg^2
```
"""
function Base.:*(abstractUnit1::AbstractUnit, abstractUnit2::AbstractUnit)
    return convertToUnit(abstractUnit1) * convertToUnit(abstractUnit2)
end

"""
    Base.:/(abstractUnit1::AbstractUnit, abstractUnit2::AbstractUnit)

Divide two objects of type `AbstractUnits` and return the result as a `Unit`.

The method ultimately calls [`Base.:/(::Unit, ::Unit)`](@ref).

# Examples
```jldoctest
julia> kilogram = Alicorn.kilogram
UnitFactor kg
julia> kilogram / kilogram
Unit <unitless>
```
"""
function Base.:/(abstractUnit1::AbstractUnit, abstractUnit2::AbstractUnit)
    return convertToUnit(abstractUnit1) / convertToUnit(abstractUnit2)
end

# implementations of AbstractUnit act as scalars in broadcasting by default
Base.broadcastable(abstractUnit::AbstractUnit) = Ref(abstractUnit)


## 2. Interface
# the following functions need to be extended for concrete implementations of
# AbstractUnit

export convertToUnit
"""
    convertToUnit(abstractUnit::AbstractUnit)::Unit

Convert any object of type `AbstractUnit` to the `Unit` subtype.
"""
function convertToUnit(abstractUnit::AbstractUnit)::Unit
    subtype = typeof(abstractUnit)
    error("subtype $subtype of AbstractUnit misses an implementation of the convertToUnit function")
end

export convertToBasicSI
"""
    convertToBasicSI(abstractUnit::AbstractUnit)

Express a unit in terms of the seven basic SI units.

# Output

`(prefactor::Real, basicUnit::Unit)`

The return variable `basicUnit` only contains powers of the seven basic SI units (kg, m, s, A, K, mol, cd). The return variable `prefactor` is the numerical prefactor relating the original unit to the returned unit.
"""
function convertToBasicSI(abstractUnit::AbstractUnit)
   subtype = typeof(abstractUnit)
   error("subtype $subtype of AbstractUnit misses an implementation of the convertToBasicSI function")
end

export convertToBasicSIAsExponents
"""
     convertToBasicSIAsExponents(abstractUnit::AbstractUnit)

Express a unit in terms of the seven basic SI units.

# Output

`(prefactor::Real, basicUnitAsExponents::BaseUnitExponents)`

The return variable `basicUnitAsExponents` indicates the powers of the seven basic SI units (kg, m, s, A, K, mol, cd) needed to represent the original unit. The return variable `prefactor` is the numerical prefactor relating the original unit to the returned unit.
"""
function convertToBasicSIAsExponents(abstractUnit::AbstractUnit)
   subtype = typeof(abstractUnit)
   error("subtype $subtype of AbstractUnit misses an implementation of the convertToBasicSIAsExponents function")
end

"""
    Base.:*(unitPrefix::UnitPrefix, abstractUnit::AbstractUnit)

Combine a unit prefix with a unit. The behavior of this function depends on the concrete subtype of `abstractUnit`.
"""
function Base.:*(unitPrefix::UnitPrefix, abstractUnit::AbstractUnit)
    subtype = typeof(abstractUnit)
    error("subtype $subtype of AbstractUnit misses an implementation of multiplication with UnitPrefix")
end

"""
    Base.:inv(abstractUnit::AbstractUnit)

Return the (multiplicative) inverse of a unit. The behavior of this function depends on the concrete subtype of `abstractUnit`.
"""
function Base.inv(abstractUnit::AbstractUnit)
    subtype = typeof(abstractUnit)
    error("subtype $subtype of AbstractUnit misses an implementation of the Base.inv function")
end

"""
    Base.:^(abstractUnit::AbstractUnit, exponent::Real)

Exponentiate a unit. The behavior of this function depends on the concrete subtype of `abstractUnit`.
"""
function Base.:^(abstractUnit::AbstractUnit, exponent::Real)
   subtype = typeof(abstractUnit)
   error("subtype $subtype of AbstractUnit misses an implementation of the Base.^ function")
end

"""
    Base.:sqrt(abstractUnit::AbstractUnit)

Take the square root of a unit. The behavior of this function depends on the concrete subtype of `abstractUnit`.
"""
function Base.:sqrt(abstractUnit::AbstractUnit)
   subtype = typeof(abstractUnit)
   error("subtype $subtype of AbstractUnit misses an implementation of the Base.sqrt function")
end

@doc raw"""
    SimpleQuantity{T<:Number} <: AbstractQuantity{T}

A physical quantity consisting of a scalar value and a physical unit.

# Fields
- `value::T`: value of the quantity
- `unit::Unit`: unit of the quantity

# Constructors
```
SimpleQuantity(::Number, ::AbstractUnit)
SimpleQuantity(::Number)
SimpleQuantity(::AbstractUnit)
```
If no unit is passed to the constructor, `unitlessUnit` is used by default. If
no value is passed to the constructor, the value is set to 1 by default.

If called with a `Quantity` as argument, the `Quantity` is expressed in terms
of the units used to store its value internally, see [`InternalUnits`](@ref).
```
SimpleQuantity(::Quantity)
```

If the type `T` is specified explicitly, Alicorn attempts to convert the `value`
accordingly:
```
SimpleQuantity{T}(::Number, ::AbstractUnit) where {T<:Number}
SimpleQuantity{T}(::Number) where {T<:Number}
SimpleQuantity{T}(::AbstractUnit) where {T<:Number}
```

# Examples
1. The quantity ``7\,\mathrm{nm}`` (seven nanometers) can be constructed using
   the constructor method as follows:
   ```jldoctest
   julia> ucat = UnitCatalogue() ;

   julia> nanometer = ucat.nano * ucat.meter
   UnitFactor nm

   julia> quantity = SimpleQuantity(7, nanometer)
   7 nm
   ```
2. Alternatively, ``7\,\mathrm{nm}`` can be constructed arithmetically:
   ```jldoctest
   julia> ucat = UnitCatalogue() ;

   julia> nm = ucat.nano * ucat.meter
   UnitFactor nm

   julia> quantity = 7nm
   7 nm
   ```
"""
mutable struct SimpleQuantity{T<:Number} <: AbstractQuantity{T}
    value::T
    unit::Unit

    function SimpleQuantity(value::T, unit::Unit) where {T<:Number}
        return new{T}(value, unit)
    end
end


## ## External constructors

SimpleQuantity(value::Number, abstractUnit::AbstractUnit) = SimpleQuantity(value, convertToUnit(abstractUnit))
SimpleQuantity(value::Number) = SimpleQuantity(value, unitlessUnit)
SimpleQuantity(abstractUnit::AbstractUnit) = SimpleQuantity(1, abstractUnit)

SimpleQuantity{T}(value::Number, abstractUnit::AbstractUnit) where {T<:Number} = SimpleQuantity(convert(T, value), abstractUnit)
SimpleQuantity{T}(value::Number) where {T<:Number} = SimpleQuantity(convert(T, value))
SimpleQuantity{T}(abstractUnit::AbstractUnit) where {T<:Number} = SimpleQuantity(T(1), abstractUnit)


## ## Methods for creating a SimpleQuantity

"""
    Base.:*(value::Number, abstractUnit::AbstractUnit)

Combine `value` and `abstractUnit` to form a physical quantity of type `SimpleQuantity`.

If `abstractUnit` is a product of a `UnitPrefix` and `BaseUnit`, they are first
combined into a `SimpleQuantity`, which is then in turn combined with `value`.

# Example
```jldoctest
julia> ucat = UnitCatalogue() ;

julia> 3.5 * ucat.milli * ucat.tesla
3.5 mT
```
"""
function Base.:*(value::Number, abstractUnit::AbstractUnit)
    return SimpleQuantity(value, abstractUnit)
end

"""
    Base.:/(value::Number, abstractUnit::AbstractUnit)

Combine `value` and `abstractUnit` to form a physical quantity of type `SimpleQuantity`.

If `abstractUnit` is a product of a `UnitPrefix` and `BaseUnit`, they are first
combined into a `SimpleQuantity`, which is then in turn combined with `value`.

# Example
```jldoctest
julia> ucat = UnitCatalogue() ;

julia> 3.5 / ucat.nano * ucat.second
3.5 ns^-1
```
"""
function Base.:/(value::Number, abstractUnit::AbstractUnit)
    inverseAbstractUnit = inv(abstractUnit)
    return SimpleQuantity(value, inverseAbstractUnit)
end

# the following definitions allow to create a simple quantity by directly
# multiplying (dividing) n::Number, pre::UnitPrefix, and base::Union{BaseUnit, UnitFactor}) without
# parentheses:
#  n * pre * base
#  n / pre * base
# instead of
#  n * (pre * base)
#  n / (pre * base)
Base.:*(value::Number, unitPrefix::UnitPrefix) = (value, unitPrefix, *)
Base.:/(value::Number, unitPrefix::UnitPrefix) = (value, unitPrefix, /)
Base.:*(valueWithUnitPrefix::Tuple{Number, UnitPrefix, typeof(*)}, baseUnit::Union{BaseUnit, UnitFactor}) = valueWithUnitPrefix[1] * ( valueWithUnitPrefix[2] * baseUnit )
Base.:*(valueWithUnitPrefix::Tuple{Number, UnitPrefix, typeof(/)}, baseUnit::Union{BaseUnit, UnitFactor}) = valueWithUnitPrefix[1] / ( valueWithUnitPrefix[2] * baseUnit )

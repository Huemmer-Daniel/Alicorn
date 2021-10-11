@doc raw"""
    Quantity{T<:Number} <: AbstractQuantity{T}

A physical quantity consisting of a number, a `Dimension` object representing
the physical dimension, and an `InternalUnits` object representing the units
with respect to which the seven basic dimensions of the SI system are measured.

The value field of a `Quantity{T}` is of type `T`, which needs to be a subtype
of `Number`.

# Fields
- `value::T`: value of the quantity
- `dimension::Dimension`: physical dimension of the quantity
- `internalUnits::InternalUnits`: set of units with respect to which the seven
basic dimensions of the SI system are measured.

# Constructors
```
Quantity(value::Number, dimension::Dimension, internalUnits::InternalUnits)
Quantity(simpleQuantity::SimpleQuantity{T}, internalUnits::InternalUnits) where T <: Number
Quantity(value::T, unit::AbstractUnit, internalUnits::InternalUnits)
```
The constructors preserve the type `T` of the value upon conversion to the
internal units whenever possible.

# Examples
1. The quantity ``7\,\mathrm{nm}`` (seven nanometers) can for instance be
   constructed as follows:
   ```jldoctest
   julia> ucat = UnitCatalogue() ;
          nm = ucat.nano*ucat.meter;
          intu = InternalUnits(length=1nm) ;

   julia> Quantity(7nm, intu)
   Quantity{Int64} of dimension L^1 in units of (1 nm):
    7
   ```
   Note that the original type `Int64` of the value is preserved.
2. If we use ``2\,\mathrm{nm}`` as internal unit for length, the value can no
   longer be represented as type `Int64` internally:
   ```jldoctest
   julia> ucat = UnitCatalogue() ;
          nm = ucat.nano*ucat.meter;
          intu = InternalUnits(length=2nm) ;

   julia> Quantity(7nm, intu)
   Quantity{Float64} of dimension L^1 in units of (2 nm):
    3.5
   ```
"""
mutable struct Quantity{T<:Number} <: AbstractQuantity{T}
    value::T
    dimension::Dimension
    internalUnits::InternalUnits
end

## External constructors

function Quantity(simpleQuantity::SimpleQuantity{T}, internalUnits::InternalUnits) where T
    dimension = dimensionOf(simpleQuantity)
    internalUnit = internalUnitForDimension(dimension, internalUnits)
    internalValue = valueInUnitsOf(simpleQuantity, internalUnit)
    internalValue = _attemptConversionToOriginalType(internalValue, T)
    return Quantity(internalValue, dimension, internalUnits)
end

function _attemptConversionToOriginalType(value::Number, T::Type)
    try
        value = convert(T, value)
    catch
    end
    return value
end

Quantity(value::Number, unit::AbstractUnit, internalUnits::InternalUnits) = Quantity(value*unit, internalUnits)

function Quantity(abstractUnit::AbstractUnit, internalUnits::InternalUnits)
    simpleQuantity = 1 * abstractUnit
    return Quantity(simpleQuantity, internalUnits)
end

## Methods implementing the interface of AbstractQuantity

"""
    Base.:(==)(quantity1::Quantity, quantity2::Quantity)

Compare two `Quantity` objects.

The two quantities are equal if their values, their dimensions, and their internal units are equal.
Note that the units are not converted during the comparison.
"""
function Base.:(==)(quantity1::Quantity, quantity2::Quantity)
    valuesEqual = ( quantity1.value == quantity2.value )
    dimensionsEqual = ( quantity1.dimension == quantity2.dimension )
    internalUnitsEqual = ( quantity1.internalUnits == quantity2.internalUnits )
    isEqual = valuesEqual && dimensionsEqual && internalUnitsEqual
    return isEqual
end

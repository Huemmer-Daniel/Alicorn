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
Quantity(value::T, dimension::Dimension, internalUnits::InternalUnits) where T <: Number
Quantity(simpleQuantity::SimpleQuantity, internalUnits::InternalUnits)
```
"""
mutable struct Quantity{T<:Number} <: AbstractQuantity{T}
    value::T
    dimension::Dimension
    internalUnits::InternalUnits
end

## External constructors

function Quantity(simpleQuantity::SimpleQuantity, internalUnits::InternalUnits)
    dimension = dimensionOf(simpleQuantity)
    internalUnit = internalUnitForDimension(dimension, internalUnits)
    internalValue = valueInUnitsOf(simpleQuantity, internalUnit)
    return Quantity(internalValue, dimension, internalUnits)
end

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

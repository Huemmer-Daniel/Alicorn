export Quantity
@doc raw"""
    Quantity{T} <: AbstractQuantity{T}

A physical quantity consisting of a scalar value, a physical dimension, and a
set of seven `SimpleQuantity` objects representing the units with respect to
which the seven basic dimensions of the SI system are measured.

`Quantity` is a parametric type, where `T` is the type of the
quantity's value. The type `T` needs to be a subtype of `Number`.

# Fields
- `value::T`: value of the quantity
- `dimension::Dimension`: physical dimension of the quantity
- `internalUnits::InternalUnits`: set of units with respect to which the seven
basic dimensions of the SI system are measured.

# Constructors
```
Quantity(value::T, dimension::Dimension, internalUnits::InternalUnits) where T <: Number
Quantity(simpleQuantity::SimpleQuantity, internalUnits::InternalUnits)
Quantity(abstractUnit::AbstractUnit, internalUnits::InternalUnits)
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
    internalUnit = _internalUnitForDimension(dimension, internalUnits)
    internalValue = valueInUnitsOf(simpleQuantity, internalUnit)
    return Quantity(internalValue, dimension, internalUnits)
end

# TODO: turn into exported function in InternalUnits
function _internalUnitForDimension(dimension, internalUnits)
    Mexp = dimension.massExponent
    Lexp = dimension.lengthExponent
    Texp = dimension.timeExponent
    Iexp = dimension.currentExponent
    Θexp = dimension.temperatureExponent
    Nexp = dimension.amountExponent
    Jexp = dimension.luminousIntensityExponent

    Munit = internalUnits.mass
    Lunit = internalUnits.length
    Tunit = internalUnits.time
    Iunit = internalUnits.current
    θunit = internalUnits.temperature
    Nunit = internalUnits.amount
    Junit = internalUnits.luminousIntensity

    internalUnit = Munit^Mexp * Lunit^Lexp * Tunit^Texp * Iunit^Iexp * θunit^Θexp * Nunit^Nexp * Junit^Jexp
    return internalUnit
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

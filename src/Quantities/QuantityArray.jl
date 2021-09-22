export QuantityArray
@doc raw"""
    QuantityArray{T,N} <: AbstractQuantity{T,N}

A physical quantity consisting of an array, a `Dimension` representing the
physical dimension, and an `InternalUnits` object representing the units with
respect to which the seven basic dimensions of the SI system are measured.

The value field of a `QuantityArray{T,N}` is of type `Array{T,N}`. `T` needs to
be a subtype of `Number`.

# Fields
- `value::Array{T,N}`: value of the quantity
- `dimension::Dimension`: physical dimension of the quantity
- `internalUnits::InternalUnits`: set of units with respect to which the seven
basic dimensions of the SI system are measured.

# Constructors
```
QuantityArray(value::Array{T,N}, dimension::Dimension, internalUnits::InternalUnits)
QuantityArray(sqArray::SimpleQuantityArray, internalUnits::InternalUnits)
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

## External constructors

function QuantityArray(sqArray::SimpleQuantityArray, internalUnits::InternalUnits)
    dimension = dimensionOf(sqArray)
    internalUnit = _internalUnitForDimension(dimension, internalUnits)
    internalValue = valueInUnitsOf(sqArray, internalUnit)
    return QuantityArray(internalValue, dimension, internalUnits)
end


## Arithemtics

"""
    Base.:(==)(qArray1::QuantityArray, qArray2::QuantityArray)

Compare two `QuantityArray` objects.

The two quantities are equal if their values, their dimensions, and their internal units are equal.
Note that the units are not converted during the comparison.
"""
function Base.:(==)(qArray1::QuantityArray, qArray2::QuantityArray)
    valuesEqual = ( qArray1.value == qArray2.value )
    dimensionsEqual = ( qArray1.dimension == qArray2.dimension )
    internalUnitsEqual = ( qArray1.internalUnits == qArray2.internalUnits )
    isEqual = valuesEqual && dimensionsEqual && internalUnitsEqual
    return isEqual
end

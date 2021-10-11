@doc raw"""
    QuantityArray{T<:Number,N} <: AbstractQuantityArray{T,N}

A physical quantity consisting of an array, a `Dimension` object representing
the physical dimension, and an `InternalUnits` object representing the units
with respect to which the seven basic dimensions of the SI system are measured.

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
QuantityArray(sqArray::SimpleQuantityArray{T}, internalUnits::InternalUnits)
QuantityArray(value::AbstractArray{T,N}, unit::AbstractUnit, internalUnits::InternalUnits) where {T<:Number, N}
```

The constructors preserve the type of the value upon conversion to the
internal units whenever possible.

# Examples
1. The vector-valued quantity ``[7, 14]\,\mathrm{nm}`` can for instance be
   constructed as follows:
   ```jldoctest
   julia> ucat = UnitCatalogue() ;
          nm = ucat.nano*ucat.meter;
          intu = InternalUnits(length=1nm) ;

   julia> QuantityArray([7, 14]nm, intu)
   2-element QuantityVector{Int64} of dimension L^1 in units of (1 nm):
     7
    14
   ```
   Note that the original type `Int64` of the value is preserved.
2. If we use ``2\,\mathrm{nm}`` as internal unit for length, the vector can no
   longer be represented as type `Vector{Int64}` internally:
   ```jldoctest
   julia> ucat = UnitCatalogue() ;
          nm = ucat.nano*ucat.meter;
          intu = InternalUnits(length=2nm) ;

   julia> QuantityArray([7, 14]nm, intu)
   2-element QuantityVector{Float64} of dimension L^1 in units of (2 nm):
    3.5
    7.0
   ```
"""
mutable struct QuantityArray{T<:Number,N} <: AbstractQuantityArray{T,N}
    value::Array{T,N}
    dimension::Dimension
    internalUnits::InternalUnits
end

"""
    QuantityVector{T}

One-dimensional array-valued quantity with elements of type `T`.

Alias for `QuantityArray{T,1}`.
"""
const QuantityVector{T} = QuantityArray{T,1}

"""
    QuantityMatrix{T}

Two-dimensional array-valued quantity with elements of type `T`.

Alias for `QuantityArray{T,2}`.
"""
const QuantityMatrix{T} = QuantityArray{T,2}

## External constructors

function QuantityArray(sqArray::SimpleQuantityArray, internalUnits::InternalUnits)
    dimension = dimensionOf(sqArray)
    internalUnit = internalUnitForDimension(dimension, internalUnits)
    internalValue = valueInUnitsOf(sqArray, internalUnit)
    internalValue = _attemptConversionToOriginalType(internalValue, typeof(sqArray.value))
    return QuantityArray(internalValue, dimension, internalUnits)
end

function _attemptConversionToOriginalType(value::AbstractArray{S,N}, T::Type) where {S<:Number, N}
    try
        value = convert(T, value)
    catch
    end
    return value
end

QuantityArray(value::AbstractArray{T,N}, unit::AbstractUnit, internalUnits::InternalUnits) where {T<:Number, N} = QuantityArray(value*unit, internalUnits)

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

## ## Methods implementing the interface of AbstractArray

Base.size(qArray::QuantityArray) = size(qArray.value)

Base.IndexStyle(::Type{<:QuantityArray}) = IndexLinear()

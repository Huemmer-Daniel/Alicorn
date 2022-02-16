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
QuantityArray(::AbstractArray, ::Dimension, ::InternalUnits)
QuantityArray(::AbstractArray, ::Dimension)
QuantityArray(::AbstractArray, ::InternalUnits)
QuantityArray(::AbstractArray)
```
If no `InternalUnits` are passed to the constructor, the basic SI units are used.
If no `Dimension` is passed to the constructor, a dimensionless
quantity is constructed.
```
QuantityArray{T}(::AbstractArray, ::Dimension, ::InternalUnits) where {T<:Number}
QuantityArray{T}(::AbstractArray, ::Dimension) where {T<:Number}
QuantityArray{T}(::AbstractArray, ::InternalUnits) where {T<:Number}
QuantityArray{T}(::AbstractArray) where {T<:Number}
```
If the type `T` is specified explicitly, Alicorn attempts to convert the
provided `AbstractArray` to `Array{T}`.
"""
mutable struct QuantityArray{T<:Number,N} <: AbstractQuantityArray{T,N}
    value::Array{T,N}
    dimension::Dimension
    internalUnits::InternalUnits

    function QuantityArray(value::Array{T,N}, dimension::Dimension, internalUnits::InternalUnits) where {T<:Number,N}
        return new{T,N}(value, dimension, internalUnits)
    end
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


## ## External constructors

QuantityArray(value::AbstractArray{T}, dimension::Dimension, internalUnits::InternalUnits) where {T<:Number} = QuantityArray( Array(value), dimension, internalUnits)
QuantityArray(value::AbstractArray{T}, dimension::Dimension) where {T<:Number} = QuantityArray( Array(value), dimension, defaultInternalUnits)
QuantityArray(value::AbstractArray{T}, internalUnits::InternalUnits) where {T<:Number} = QuantityArray( Array(value), dimensionless, internalUnits)
QuantityArray(value::AbstractArray{T}) where {T<:Number} = QuantityArray( Array(value), dimensionless, defaultInternalUnits)


QuantityArray{T}(value::AbstractArray, dimension::Dimension, internalUnits::InternalUnits) where {T<:Number} = QuantityArray(convert(Array{T}, value), dimension, internalUnits)
QuantityArray{T}(value::AbstractArray, dimension::Dimension) where {T<:Number} = QuantityArray(convert(Array{T}, value), dimension, defaultInternalUnits)
QuantityArray{T}(value::AbstractArray, internalUnits::InternalUnits) where {T<:Number} = QuantityArray(convert(Array{T}, value), dimensionless, internalUnits)
QuantityArray{T}(value::AbstractArray) where {T<:Number} = QuantityArray(convert(Array{T}, value), dimensionless, defaultInternalUnits)

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

function Base.getindex(qArray::QuantityArray, inds...)
    dimension = qArray.dimension
    internalUnits = qArray.internalUnits
    array = qArray.value

    subarray = getindex(array, inds...)

    if length(subarray) == 1
        return Quantity(subarray, dimension, internalUnits)
    else
        return QuantityArray(subarray, dimension, internalUnits)
    end
end

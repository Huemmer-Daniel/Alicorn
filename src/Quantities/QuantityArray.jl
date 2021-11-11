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
The constructors preserve the type `T` of the value upon conversion to the
internal units whenever possible. If no `InternalUnits` are passed to the
constructor, the basic SI units are used by default.

Construction from value and dimension; if no dimension is passed to the
constructor, a dimensionless quantity is constructed by default.
```
        @test canConstructFromQuantity_TypeSpecified()
QuantityArray(::AbstractArray, ::Dimension, ::InternalUnits)
QuantityArray(::AbstractArray, ::Dimension)
QuantityArray(::AbstractArray, ::InternalUnits)
QuantityArray(::AbstractArray)
QuantityArray(::Quantity)
```
If the type `T` is specified explicitly, Alicorn attempts to convert the `value`
accordingly:
```
QuantityArray{T}(::AbstractArray, ::Dimension, ::InternalUnits) where {T<:Number}
QuantityArray{T}(::AbstractArray, ::Dimension) where {T<:Number}
QuantityArray{T}(::AbstractArray, ::InternalUnits) where {T<:Number}
QuantityArray{T}(::AbstractArray) where {T<:Number}
QuantityArray{T}(::QuantityArray) where {T<:Number}
QuantityArray{T}(::Quantity) where {T<:Number}
```

Construction from a `SimpleQuantityArray`:
```
QuantityArray(::SimpleQuantityArray, ::InternalUnits)
QuantityArray(::SimpleQuantityArray)
```

Construction from value and unit; if no unit is passed to the constructor, a
dimensionless quantity is constructed by default.
```
QuantityArray(::AbstractArray{T}, ::AbstractUnit, ::InternalUnits) where {T<:Number}
QuantityArray(::AbstractArray{T}, ::AbstractUnit) where {T<:Number}
```

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


## External constructors

QuantityArray(value::AbstractArray{T}, dimension::Dimension, internalUnits::InternalUnits) where {T<:Number} = QuantityArray( Array(value), dimension, internalUnits)
QuantityArray(value::AbstractArray{T}, dimension::Dimension) where {T<:Number} = QuantityArray( Array(value), dimension, InternalUnits())
QuantityArray(value::AbstractArray{T}, internalUnits::InternalUnits) where {T<:Number} = QuantityArray( Array(value), Dimension(), internalUnits)
QuantityArray(value::AbstractArray{T}) where {T<:Number} = QuantityArray( Array(value), Dimension(), InternalUnits())
QuantityArray(qArray::QuantityArray) = qArray
QuantityArray(quantity::Quantity) = QuantityArray([quantity.value], quantity.dimension, quantity.internalUnits)

QuantityArray{T}(value::AbstractArray, dimension::Dimension, internalUnits::InternalUnits) where {T<:Number} = QuantityArray(convert(Array{T}, value), dimension, internalUnits)
QuantityArray{T}(value::AbstractArray, dimension::Dimension) where {T<:Number} = QuantityArray(convert(Array{T}, value), dimension, InternalUnits())
QuantityArray{T}(value::AbstractArray, internalUnits::InternalUnits) where {T<:Number} = QuantityArray(convert(Array{T}, value), Dimension(), internalUnits)
QuantityArray{T}(value::AbstractArray) where {T<:Number} = QuantityArray(convert(Array{T}, value), Dimension(), InternalUnits())
QuantityArray{T}(qArray::QuantityArray) where {T<:Number} = QuantityArray(convert(Array{T}, qArray.value), qArray.dimension, qArray.internalUnits)
QuantityArray{T}(quantity::Quantity) where {T<:Number} = QuantityArray{T}([quantity.value], quantity.dimension, quantity.internalUnits)

# from SimpleQuantityArray
function QuantityArray(sqArray::SimpleQuantityArray, internalUnits::InternalUnits)
    dimension = dimensionOf(sqArray)
    internalUnit = internalUnitFor(dimension, internalUnits)
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

QuantityArray(sqArray::SimpleQuantityArray) = QuantityArray(sqArray, InternalUnits())

# from value and unit
QuantityArray(value::AbstractArray{T}, unit::AbstractUnit, internalUnits::InternalUnits) where {T<:Number} = QuantityArray(value*unit, internalUnits)
QuantityArray(value::AbstractArray{T}, unit::AbstractUnit) where {T<:Number} = QuantityArray(value, unit, InternalUnits())


## ## Type conversion

"""
    Base.convert(::Type{T}, qArray::QuantityArray) where {T<:QuantityArray}

Convert `qArray` from type `QuantityArray{S} where S` to type `QuantityArray{T}`.

Allows to convert, for instance, from `QuantityArray{Float64}` to `QuantityArray{UInt8}`.
"""
Base.convert(::Type{T}, qArray::QuantityArray) where {T<:QuantityArray} = qArray isa T ? qArray : T(qArray)


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

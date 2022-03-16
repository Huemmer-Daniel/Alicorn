@doc raw"""
    SimpleQuantityArray{T<:Number,N} <: AbstractQuantityArray{T,N}

A physical quantity consisting of a number array and a physical unit.

The value field of a `SimpleQuantityArray{T,N}` is of type `Array{T,N}`. `T`
needs to be a subtype of `Number`.

# Fields
- `value::Array{T,N}`: value of the quantity
- `unit::Unit`: unit of the quantity

# Constructors
```
SimpleQuantityArray(::AbstractArray, ::AbstractUnit)
SimpleQuantityArray(::AbstractArray)
```
If no unit is passed to the constructor, `unitlessUnit` is used by default.
```
SimpleQuantityArray{T}(::AbstractArray, ::AbstractUnit) where {T<:Number}
SimpleQuantityArray{T}(::AbstractArray) where {T<:Number}
```
If the type `T` is specified explicitly, Alicorn attempts to convert the `value`
accordingly.
"""
mutable struct SimpleQuantityArray{T<:Number,N} <: AbstractQuantityArray{T,N}
    value::Array{T,N}
    unit::Unit

    function SimpleQuantityArray(value::Array{T,N}, unit::Unit) where {T<:Number, N}
        return new{T,N}(value, unit)
    end
end

"""
    SimpleQuantityVector{T}

One-dimensional array-valued simple quantity with elements of type `T`.

Alias for `SimpleQuantityArray{T,1}`.
"""
const SimpleQuantityVector{T} = SimpleQuantityArray{T,1}

"""
    SimpleQuantityMatrix{T}

Two-dimensional array-valued simple quantity with elements of type `T`.

Alias for `SimpleQuantityArray{T,2}`.
"""
const SimpleQuantityMatrix{T} = SimpleQuantityArray{T,2}


## ## External constructors

SimpleQuantityArray(value::AbstractArray{T}, abstractUnit::AbstractUnit) where {T<:Number} = SimpleQuantityArray( Array(value), convertToUnit(abstractUnit) )
SimpleQuantityArray(value::AbstractArray{T}) where {T<:Number} = SimpleQuantityArray(value, unitlessUnit)

SimpleQuantityArray{T}(value::AbstractArray, abstractUnit::AbstractUnit) where {T<:Number} = SimpleQuantityArray( convert(Array{T}, value), abstractUnit)
SimpleQuantityArray{T}(value::AbstractArray) where {T<:Number} = SimpleQuantityArray( convert(Array{T}, value) )


## ## Methods for creating a SimpleQuantityArray

"""
    Base.:*(value::AbstractArray{T}, abstractUnit::AbstractUnit) where {T<:Number}

Combine the array `value` and `abstractUnit` to form a physical quantity of type `SimpleQuantityArray`.

If `abstractUnit` is a product of a `UnitPrefix` and `BaseUnit`, they are first
combined into a `SimpleQuantity`, which is then in turn combined with `value`.

# Example
```jldoctest
julia> ucat = UnitCatalogue() ;

julia> [3.5, 4.6] * ucat.milli * ucat.tesla
2-element SimpleQuantityVector{Float64} of unit mT:
 3.5
 4.6
```
"""
function Base.:*(value::AbstractArray{T}, abstractUnit::AbstractUnit) where {T<:Number}
    return SimpleQuantityArray(value, abstractUnit)
end

"""
    Base.:/(value::AbstractArray{T}, abstractUnit::AbstractUnit) where {T<:Number}

Combine the array `value` and `abstractUnit` to form a physical quantity of type `SimpleQuantityArray`.

If `abstractUnit` is a product of a `UnitPrefix` and `BaseUnit`, they are first
combined into a `SimpleQuantity`, which is then in turn combined with `value`.

# Example
```jldoctest
julia> ucat = UnitCatalogue() ;

julia> [3.5, 4.6] / ucat.nano * ucat.second
2-element SimpleQuantityVector{Float64} of unit ns^-1:
 3.5
 4.6
```
"""
function Base.:/(value::AbstractArray{T}, abstractUnit::AbstractUnit) where {T<:Number}
    inverseAbstractUnit = inv(abstractUnit)
    return SimpleQuantityArray(value, inverseAbstractUnit)
end

# the following definitions allow to create a simple quantity by directly
# multiplying (dividing) n::Array, pre::UnitPrefix, and base::Union{BaseUnit, UnitFactor}) without
# parentheses:
#  n * pre * base
#  n / pre * base
# instead of
#  n * (pre * base)
#  n / (pre * base)
Base.:*(array::AbstractArray{T}, unitPrefix::UnitPrefix) where {T<:Number} = (array, unitPrefix, *)
Base.:/(array::AbstractArray{T}, unitPrefix::UnitPrefix) where {T<:Number} = (array, unitPrefix, /)
Base.:*(arrayWithUnitPrefix::Tuple{AbstractArray{T}, UnitPrefix, typeof(*)}, baseUnit::Union{BaseUnit, UnitFactor}) where {T<:Number} = arrayWithUnitPrefix[1] * ( arrayWithUnitPrefix[2] * baseUnit )
Base.:*(arrayWithUnitPrefix::Tuple{AbstractArray{T}, UnitPrefix, typeof(/)}, baseUnit::Union{BaseUnit, UnitFactor}) where {T<:Number} = arrayWithUnitPrefix[1] / ( arrayWithUnitPrefix[2] * baseUnit )

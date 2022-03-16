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
The constructors preserve the type `T` of the value upon conversion to the
internal units whenever possible. If no `InternalUnits` are passed to the
constructor, the basic SI units are used by default.

Construction from value and dimension; if no dimension is passed to the
constructor, a dimensionless quantity is constructed by default.
```
Quantity(::Number, ::Dimension, ::InternalUnits)
Quantity(::Number, ::Dimension)
Quantity(::Number, ::InternalUnits)
Quantity(::Number)
```
If the type `T` is specified explicitly, Alicorn attempts to convert the `value`
accordingly:
```
Quantity{T}(::Number, ::Dimension, ::InternalUnits) where {T<:Number}
Quantity{T}(::Number, ::Dimension) where {T<:Number}
Quantity{T}(::Number, ::InternalUnits) where {T<:Number}
Quantity{T}(::Number) where {T<:Number}
```

Construction from value and unit; if no unit is passed to the constructor, a
dimensionless quantity is constructed by default.
```
Quantity(::Number, ::AbstractUnit, ::InternalUnits)
Quantity(::Number, ::AbstractUnit)
Quantity(::AbstractUnit, ::InternalUnits)
Quantity(::AbstractUnit)
```

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

    function Quantity(value::T, dimension::Dimension, internalUnits::InternalUnits) where {T<:Number}
        return new{T}(value, dimension, internalUnits)
    end
end

## External constructors

Quantity(value::Number, dimension::Dimension) = Quantity(value, dimension, defaultInternalUnits)
Quantity(value::Number, internalUnits::InternalUnits) = Quantity(value, dimensionless, internalUnits)
Quantity(value::Number) = Quantity(value, dimensionless, defaultInternalUnits)

Quantity{T}(value::Number, dimension::Dimension, internalUnits::InternalUnits) where {T<:Number} = Quantity(convert(T, value), dimension, internalUnits)
Quantity{T}(value::Number, dimension::Dimension) where {T<:Number} = Quantity{T}(value, dimension, defaultInternalUnits)
Quantity{T}(value::Number, internalUnits::InternalUnits) where {T<:Number} = Quantity{T}(value, dimensionless, internalUnits)
Quantity{T}(value::Number) where {T<:Number} = Quantity{T}(value, dimensionless, defaultInternalUnits)

```@meta
DocTestSetup = quote
    using Alicorn
end
```

# Quantities

The `Quantities` submodule is concerned with defining and manipulating physical quantities.

Unless stated otherwise, all types, functions, and constants defined in the submodule are exported to the global scope.

#### Contents

```@contents
Pages = ["quantities.md"]
Depth = 3
```

## Overview

Alicorn distinguishes scalar (number-valued) and array (vector-, matrix-, or
tensor-valued) quantities. The abstract supertype for all scalar quantities is
[`AbstractQuantity`](@ref), while the abstract supertype for all array
quantities is [`AbstractQuantityArray`](@ref). `AbstractQuantityArray` is a
subtype of `Base.AbstractArray` and implements its interface.

### Types Representing Quantities

There are two concrete implementations of each supertype:
- [`SimpleQuantity`](@ref) and [`Quantity`](@ref) for scalar quantities, and
- [`SimpleQuantityArray`](@ref) and [`QuantityArray`](@ref) for array quantities.

The type graph for physical quantities is
```
AbstractQuantity{T}
├─ SimpleQuantity{T}
└─ Quantity{T}

AbstractQuantityArray{T,N} <: AbstractArray{T,N}
├─ SimpleQuantityArray{T,N}
└─ QuantityArray{T,N}
```

The `SimpleQuantity` and `SimpleQuantityArray` types store their numerical
values expressed directly with respect to their unit.

The `Quantity` and `QuantityArray` types store their numerical values expressed
with respect to a shared set of internal units for the seven basic physical
dimensions of the SI system. These internal units are represented by a
[`InternalUnits`](@ref) object. Instead of a concrete units for each quantity,
only their physical dimension is retained. This approach can reduce the need for
unit conversions during calculations. Moreover, it facilitates the use of a
global set of internal units adapted to the magnitudes of the quantities
appearing in a given calculation.

### Type Aliases

Alicorn defines the following aliases for one- and two-dimensional arrays:

| Type name | Mathematical dimension | Role  | Alias for | Carries physical dimension |
| :---      | :---:           | :---: | :---:        | :---:        |
| [`AbstractQuantity{T}`](@ref) | N=0 | abstract supertype | - | yes |
| [`AbstractQuantityVector{T}`](@ref) | N=1 | abstract supertype | `AbstractQuantityArray{T,1}` | yes |
| [`AbstractQuantityMatrix{T}`](@ref) | N=2 | abstract supertype | `AbstractQuantityArray{T,2}` | yes |
| [`AbstractQuantityArray{T,N}`](@ref) | N | abstract supertype | - | yes |
| [`SimpleQuantity{T}`](@ref) | N=0 | concrete type | - | yes |
| [`SimpleQuantityVector{T}`](@ref) | N=1 | concrete type | `SimpleQuantityArray{T,1}` | yes |
| [`SimpleQuantityMatrix{T}`](@ref) | N=2 | concrete type | `SimpleQuantityArray{T,2}` | yes |
| [`SimpleQuantityArray{T,N}`](@ref) | N | concrete type | - | yes |
| [`Quantity{T}`](@ref) | N=0 | concrete type | - | yes |
| [`QuantityVector{T}`](@ref) | N=1 | concrete type | `QuantityArray{T,1}` | yes |
| [`QuantityMatrix{T}`](@ref) | N=2 | concrete type | `QuantityArray{T,2}` | yes |
| [`QuantityArray{T,N}`](@ref) | N | concrete type | - | yes |

Type unions for scalar and array quantities of the same kind:

| Type name | Role  | Alias for | Carries physical dimension |
| :---      | :---: | :---:        | :---:        |
| [`AbstractQuantityType{T}`](@ref) | type union | `Union{AbstractQuantity{T}, AbstractQuantityArray{T}} where T<:Number` | yes |
| [`SimpleQuantityType{T}`](@ref) | type union | `Union{SimpleQuantity{T}, SimpleQuantityArray{T}} where T<:Number` | yes |
| [`QuantityType{T}`](@ref) | type union | `Union{Quantity{T}, QuantityArray{T}} where T<:Number` | yes |
| [`DimensionlessType{T}`](@ref) | type union | `Union{Number, AbstractArray{<:Number}} where T<:Number` | no |

Type unions for scalar and array quantities:

| Type name | Mathematical dimension | Role  | Alias for | Carries physical dimension |
| :---      | :---:           | :---: | :---:        | :---:        |
| [`ScalarQuantity{T}`](@ref) | N=0 | type union | `Union{T, AbstractQuantity{T}} where T<:Number` | either yes or no |
| [`VectorQuantity{T}`](@ref) | N=1 | type union | `Union{T, AbstractQuantityVector{T}} where T<:Number` | either yes or no |
| [`MatrixQuantity{T}`](@ref) | N=2 | type union | `Union{T, AbstractQuantityMatrix{T}} where T<:Number` | either yes or no |
| [`ArrayQuantity{T,N}`](@ref) | N | type union | `Union{Array{T,N}, AbstractQuantityArray{T,N}} where {T<:Number, N}` | either yes or no |

```@docs
AbstractQuantityType
SimpleQuantityType
QuantityType
DimensionlessType
```

## InternalUnits

```@docs
InternalUnits
Base.:(==)(::InternalUnits, ::InternalUnits)
internalUnitFor(::Dimension, ::InternalUnits)
conversionFactor(::Dimension, ::InternalUnits, ::InternalUnits)
```


## Scalar Quantities

### Types

```@docs
AbstractQuantity
SimpleQuantity
Quantity
ScalarQuantity
```

### Construction

```@docs
Base.:*(::Number, ::AbstractUnit)
Base.:/(::Number, ::AbstractUnit)
```

### Dimension

```@docs
dimensionOf(::AbstractQuantity)
```

### Type conversion

```@docs
SimpleQuantity(::AbstractQuantity)
SimpleQuantity{T}(::AbstractQuantity) where {T<:Number}
Quantity(::AbstractQuantity, ::InternalUnits)
Quantity{T}(::AbstractQuantity, ::InternalUnits) where T<:Number
Base.convert(::Type{T}, ::SimpleQuantity) where {T<:SimpleQuantity}
Base.convert(::Type{T}, ::Quantity) where {T<:Quantity}
```

### Unit Conversion

```@docs
inUnitsOf(::AbstractQuantity, ::AbstractUnit)
inBasicSIUnits(::AbstractQuantity)
valueInUnitsOf(::AbstractQuantity, ::AbstractUnit)
valueInUnitsOf(::AbstractQuantity{T}, ::SimpleQuantity) where T
valueOfDimensionless(::AbstractQuantity)
Base.:*(::AbstractQuantity, ::AbstractUnit)
Base.:/(::AbstractQuantity, ::AbstractUnit)
inInternalUnitsOf(::QuantityArray, ::InternalUnits)
```

## Array Quantities

### Types

```@docs
AbstractQuantityArray
AbstractQuantityVector
AbstractQuantityMatrix
SimpleQuantityArray
SimpleQuantityVector
SimpleQuantityMatrix
QuantityArray
QuantityVector
QuantityMatrix
VectorQuantity
MatrixQuantity
ArrayQuantity
```

### Construction

```@docs
Base.:*(::AbstractArray{T}, ::AbstractUnit) where {T<:Number}
Base.:/(::AbstractArray{T}, ::AbstractUnit) where {T<:Number}
```

### Dimension

```@docs
dimensionOf(::AbstractQuantityArray)
```

### Type Conversion

```@docs
SimpleQuantityArray(::AbstractQuantityArray)
SimpleQuantityArray{T}(quantityArray::AbstractQuantityArray) where T<:Number
SimpleQuantityArray(::AbstractQuantity)
SimpleQuantityArray{T}(quantity::AbstractQuantity) where T<:Number
QuantityArray(::AbstractQuantityArray, ::InternalUnits)
QuantityArray{T}(::AbstractQuantityArray, ::InternalUnits) where T<:Number
QuantityArray(::AbstractQuantity, ::InternalUnits)
QuantityArray{T}(::AbstractQuantity, ::InternalUnits) where T<:Number
Base.convert(::Type{T}, ::SimpleQuantityArray) where {T<:SimpleQuantityArray}
Base.convert(::Type{T}, ::QuantityArray) where {T<:QuantityArray}
```


### Unit Conversion

```@docs
inUnitsOf(::AbstractQuantityArray, ::AbstractUnit)
inBasicSIUnits(::AbstractQuantityArray)
valueInUnitsOf(::AbstractQuantityArray, ::AbstractUnit)
valueInUnitsOf(::AbstractQuantityArray{T}, ::SimpleQuantity) where T
valueOfDimensionless(::AbstractQuantityArray)
Base.:*(::AbstractQuantityArray, ::AbstractUnit)
Base.:/(::AbstractQuantityArray, ::AbstractUnit)
inInternalUnitsOf(::Quantity, ::InternalUnits)
```

## Array Methods

`AbstractQuantityArray` and (where applicable) `AbstractQuantity` extend the interface of `AbstractArray` from Julia base.

| Method | Implemented for | Remak |
| :---      | :---:           | :---:           |
| `Base.size` | [`AbstractQuantityType`](@ref) | |
| `Base.IndexStyle`   |  [`AbstractQuantityType`](@ref) | returns `IndexLinear()` |
| `Base.getindex`   |  [`AbstractQuantityType`](@ref) | returns `SimpleQuantity` or `Quantity` if a single element is indexed |
| `Base.setindex!`  |  [`AbstractQuantityType`](@ref) | the assigned values have to be of matching type, e.g., `SimpleQuantity` or `SimpleQuantityArray` when assigning to a `SimpleQuantityArray` |

Alicorn also extends the following methods for handling arrays from Julia base:

| Method | Implemented for |
| :---      | :---:           |
| `Base.eltype` | [`AbstractQuantityType`](@ref) |
| `Base.copy` | [`AbstractQuantityType`](@ref) |
| `Base.deepcopy` | [`AbstractQuantityType`](@ref) |
| `Base.axes` | [`AbstractQuantityType`](@ref) |
| `Base.ndims` | [`AbstractQuantityType`](@ref) |
| `Base.length` | [`AbstractQuantityType`](@ref) |
| `Base.firstindex` | [`AbstractQuantityType`](@ref) |
| `Base.lastindex` | [`AbstractQuantityType`](@ref) |
| `Base.IteratorSize` | [`AbstractQuantity`](@ref) |
| `Base.keys` | [`AbstractQuantityType`](@ref) |
| `Base.get` | [`AbstractQuantityType`](@ref) |
| `Base.first` | [`AbstractQuantityType`](@ref) |
| `Base.last` | [`AbstractQuantityType`](@ref) |
| `Base.deleteat!` | [`AbstractQuantityVector`](@ref) |
| `Base.repeat` | [`AbstractQuantityArray`](@ref) |
| `Base.iterate` | [`ScalarQuantity`](@ref) |

## Mathematics

Alicorn extends the following basic mathematical functions from Julia base to operate on `AbstractQuantity` and `AbstractQuantityArray` types.

### Arithmetics

Binary operations involving two quantities generally show the followig behavior:
- if a [`QuantityType`](@ref) object is combined with a [`SimpleQuantityType`](@ref), the result is of type [`QuantityType`](@ref).
- if two [`SimpleQuantityType`](@ref) objects of the same dimension are added or subtracted, the result inherits the unit of the first argument
- if two [`QuantityType`](@ref) objects are combined, the result inherits the [`InternalUnits`](@ref) of the first argument

| Method | Supports broadcasting |
| :---      | :---:           |
| unary plus `Base.:+(::AbstractQuantityType)` | yes |
| unary minus `Base.:-(::AbstractQuantityType)` | yes |
| addition `Base.:+` | yes |
| subtraction `Base.:-` | yes |
| multiplication `Base.:*` | yes |
| division `Base.:*` | yes |
| power `Base.:^` | yes |
| inverse `Base.inv` | yes |


```@docs
Base.:+(q1::SimpleQuantityType, q2::SimpleQuantityType)
Base.:+(q1::Quantity, q2::Quantity)
Base.:+(q1::SimpleQuantity, q2::Quantity)
Base.:-(q1::SimpleQuantityType, q2::SimpleQuantityType)
Base.:-(q1::QuantityType, q2::QuantityType)
Base.:-(q1::SimpleQuantityType, q2::QuantityType)
```

### Numeric Comparison

Numeric comparison is only possible between
- [`SimpleQuantityType`](@ref) objects that have the same units
- [`QuantityType`](@ref) objects that have the same internal units.
In particular, comparison with `==` fails if this is not the case.

| Method | Supports broadcasting | Remarks |
| :---      | :---:           |:---:           |
| `Base.(==)` | yes | |
| `Base.<` | yes | |
| `Base.(<=)` | yes | |
| `Base.>` | yes | |
| `Base.(>=)` | yes | |
| `Base.isapprox` | yes | |
| `Base.isfinite` | no | only for [`AbstractQuantity`](@ref) |
| `Base.isinf` | no | only for [`AbstractQuantity`](@ref) |
| `Base.isnan` | no | only for [`AbstractQuantity`](@ref) |

```@docs
Base.:(==)(::SimpleQuantityType, ::SimpleQuantityType)
Base.:(==)(::QuantityType, ::QuantityType)
Base.isless(::SimpleQuantity, ::SimpleQuantity)
Base.isless(::Quantity, ::Quantity)
Base.isapprox(::SimpleQuantityType, ::SimpleQuantityType)
Base.isapprox(::QuantityType, ::QuantityType)
```

### Sign and Absolute Value

| Method | Supports broadcasting | Remarks |
| :---      | :---:           |:---:           |
| `Base.abs` | yes | only for [`AbstractQuantity`](@ref) |
| `Base.abs2` | yes | only for [`AbstractQuantity`](@ref) |
| `Base.sign` | yes | only for [`AbstractQuantity`](@ref) |
| `Base.signbit` | no | only for [`AbstractQuantity`](@ref) |
| `Base.copysign` | no | only for [`AbstractQuantity`](@ref) |
| `Base.flipsign` | no | only for [`AbstractQuantity`](@ref) |

### Roots

| Method | Supports broadcasting | Remarks |
| :---      | :---:           |:---:           |
| `Base.sqrt` | yes | only for [`AbstractQuantity`](@ref) |
| `Base.cbrt` | yes | only for [`AbstractQuantity`](@ref) |

### Complex Numbers

| Method | Supports broadcasting | Remarks |
| :---      | :---:           |:---:           |
| `Base.real` | yes |  |
| `Base.imag` | yes |  |
| `Base.angle` | yes | only for [`AbstractQuantity`](@ref) |
| `Base.conj` | yes |  |

## Broadcasting

Alicorn offers broadcasting for most mathematical functions available for quantities. For example:
```jldoctest
julia> ucat = UnitCatalogue() ;

julia> M = [2 3; 4 5] * ucat.meter ;

julia> q = Quantity(2 * ucat.meter) ;

julia> M .+ q
2×2 QuantityMatrix{Int64} of dimension L^1 in units of (1 m):
 4  5
 6  7
```
The tables in the previous section indicate which functions support broadcasting.


```@meta
DocTestSetup = nothing
```

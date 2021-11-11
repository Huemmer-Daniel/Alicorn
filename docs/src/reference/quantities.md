```@meta
DocTestSetup = quote
    using Alicorn
end
```

# Quantities

This section describes the Quantities submodule of Alicorn. The module is concerned with defining and manipulating physical quantities.

Unless stated otherwise, all types, functions, and constants defined in the submodule are exported to the global scope.

#### Contents

```@contents
Pages = ["quantities.md"]
Depth = 3
```

## Overview

Alicorn distinguishes scalar (number-valued) and array (vector-, matrix-, or
tensor-valued) quantities. The abstract superype for all scalar quantities is
[`AbstractQuantity`](@ref), while the abstract supertype for all array
quantities is [`AbstractQuantityArray`](@ref). `AbstractQuantityArray` is a
subtype of `Base.AbstractQuantity` and implements its interface.

#### Types representing quantities

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

#### Type aliases

Alicorn defines aliases for one- and two-dimensional arrays, and type unions
representing both dimensional and dimensionless values.

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
| [`ScalarQuantity{T}`](@ref) | N=0 | type union | `Union{T, AbstractQuantity{T}} where T<:Number` | either yes or no |
| [`VectorQuantity{T}`](@ref) | N=1 | type union | `Union{T, AbstractQuantityVector{T}} where T<:Number` | either yes or no |
| [`MatrixQuantity{T}`](@ref) | N=2 | type union | `Union{T, AbstractQuantityMatrix{T}} where T<:Number` | either yes or no |
| [`ArrayQuantity{T,N}`](@ref) | N | type union | `Union{Array{T,N}, AbstractQuantityArray{T,N}} where {T<:Number, N}` | either yes or no |


## Scalar quantities

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

### Type conversion

```@docs
SimpleQuantity(::AbstractQuantity)
SimpleQuantity{T}(::AbstractQuantity) where {T<:Number}
Base.convert(::Type{T}, ::SimpleQuantity) where {T<:SimpleQuantity}
Quantity(::AbstractQuantity)
Quantity{T}(::AbstractQuantity) where {T<:Number}
Base.convert(::Type{T}, ::Quantity) where {T<:Quantity}
```

### Dimension


### Unit conversion

```@docs
inUnitsOf(::AbstractQuantity, ::AbstractUnit)
inBasicSIUnits(::AbstractQuantity)
valueInUnitsOf(::AbstractQuantity, ::AbstractUnit)
valueInUnitsOf(::AbstractQuantity, ::SimpleQuantity)
valueOfDimensionless(::AbstractQuantity)
valueOfDimensionless(::SimpleQuantity)
```

```@docs
Base.:*(::AbstractQuantity, ::AbstractUnit)
Base.:/(::AbstractQuantity, ::AbstractUnit)
```

### Arithmetics, elementary functions

```@docs
Base.:+(::SimpleQuantity, ::SimpleQuantity)
Base.:-(::SimpleQuantity, ::SimpleQuantity)
Base.isless(::SimpleQuantity, ::SimpleQuantity)
Base.isapprox(::SimpleQuantity, ::SimpleQuantity)
```

### Numeric comparison

```@docs
Base.:(==)(::SimpleQuantity, ::SimpleQuantity)
Base.:(==)(::Quantity, ::Quantity)
```

### Rounding

### Sign, absolute value

### Complex numbers



## Array quantities

### Types

#### Array-valued abstract supertypes

```@docs
AbstractQuantityArray
AbstractQuantityVector
AbstractQuantityMatrix
```

#### Array-valued simple quantities

```@docs
SimpleQuantityArray
SimpleQuantityVector
SimpleQuantityMatrix
```

#### Array-valued quantities

```@docs
QuantityArray
QuantityVector
QuantityMatrix
```

#### Aliases for arrays with or without units

```@docs
VectorQuantity
MatrixQuantity
ArrayQuantity
```

### Construction and type conversion

```@docs
Base.:*(::AbstractArray{T}, ::AbstractUnit) where {T<:Number}
Base.:/(::AbstractArray{T}, ::AbstractUnit) where {T<:Number}
Base.convert(::Type{T}, ::SimpleQuantityArray) where {T<:SimpleQuantityArray}
Base.convert(::Type{T}, ::QuantityArray) where {T<:QuantityArray}
```


### Dimension

### Unit conversion

```@docs
inUnitsOf(::AbstractQuantityArray, ::AbstractUnit)
inBasicSIUnits(::AbstractQuantityArray)
valueInUnitsOf(::AbstractQuantityArray, ::AbstractUnit)
valueInUnitsOf(::AbstractQuantityArray, ::SimpleQuantity)
valueOfDimensionless(::AbstractQuantityArray)
Base.:*(::AbstractQuantityArray, ::AbstractUnit)
Base.:/(::AbstractQuantityArray, ::AbstractUnit)
```

### Arithmetics, elementary functions

```@docs
Base.:+(::SimpleQuantityArray, ::SimpleQuantityArray)
Base.:-(::SimpleQuantityArray, ::SimpleQuantityArray)
```

### Numeric comparison

```@docs
Base.:(==)(::SimpleQuantityArray, ::SimpleQuantityArray)
Base.:(==)(::QuantityArray, ::QuantityArray)
Base.isapprox(::SimpleQuantityArray, ::SimpleQuantityArray)
```


## InternalUnits

```@docs
InternalUnits
Base.:(==)(::InternalUnits, ::InternalUnits)
internalUnitFor(::Dimension, ::InternalUnits)
conversionFactor(::InternalUnits, ::InternalUnits)
```

```@meta
DocTestSetup = nothing
```

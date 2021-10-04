```@meta
DocTestSetup = quote
    using Alicorn
end
```

# Quantities

This section describes the Quantities submodule of Alicorn. The module is concerned with defining and manipulating physical quantities.

Unless stated otherwise, all types, functions, and constants defined in the submodule are exported by Alicorn.

#### Contents

```@contents
Pages = ["quantities.md"]
```

#### Quantities

```@docs
AbstractQuantity
SimpleQuantity
Quantity
```

```@docs
Base.:*(::Number, ::AbstractUnit)
Base.:/(::Number, ::AbstractUnit)
```

## Unit conversion

```@docs
inUnitsOf(::AbstractQuantity, ::AbstractUnit)
inBasicSIUnits(::AbstractQuantity)
valueInUnitsOf(::AbstractQuantity, ::AbstractUnit)
valueInUnitsOf(::AbstractQuantity, ::SimpleQuantity)
valueOfDimensionless(::AbstractQuantity)
```

```@docs
Base.:*(::AbstractQuantity, ::AbstractUnit)
Base.:/(::AbstractQuantity, ::AbstractUnit)
```

```@docs
valueOfDimensionless(::SimpleQuantity)
Base.:(==)(::SimpleQuantity, ::SimpleQuantity)
Base.:(==)(::Quantity, ::Quantity)
Base.:+(::SimpleQuantity, ::SimpleQuantity)
Base.:-(::SimpleQuantity, ::SimpleQuantity)
Base.isless(::SimpleQuantity, ::SimpleQuantity)
Base.isapprox(::SimpleQuantity, ::SimpleQuantity)
Base.zero(::Type, ::AbstractUnit)
```

#### Quantity Arrays

```@docs
AbstractQuantityArray
SimpleQuantityArray
QuantityArray
```

```@docs
Base.:*(::AbstractArray{T,N}, ::AbstractUnit) where {T<:Number, N}
Base.:/(::AbstractArray{T,N}, ::AbstractUnit) where {T<:Number, N}
```

## Unit conversion
```@docs
inUnitsOf(::AbstractQuantityArray, ::AbstractUnit)
inBasicSIUnits(::AbstractQuantityArray)
valueInUnitsOf(::AbstractQuantityArray, ::AbstractUnit)
valueInUnitsOf(::AbstractQuantityArray, ::SimpleQuantity)
valueOfDimensionless(::AbstractQuantityArray)
Base.:*(::AbstractQuantityArray, ::AbstractUnit)
Base.:/(::AbstractQuantityArray, ::AbstractUnit)
```

```@docs
Base.:(==)(::SimpleQuantityArray, ::SimpleQuantityArray)
Base.:(==)(::QuantityArray, ::QuantityArray)
Base.isapprox(::SimpleQuantityArray, ::SimpleQuantityArray)
Base.:+(::SimpleQuantityArray, ::SimpleQuantityArray)
Base.:-(::SimpleQuantityArray, ::SimpleQuantityArray)
```

## InternalUnits

```@docs
InternalUnits
Base.:(==)(::InternalUnits, ::InternalUnits)
internalUnitForDimension(::Dimension, ::InternalUnits)
```

```@meta
DocTestSetup = nothing
```

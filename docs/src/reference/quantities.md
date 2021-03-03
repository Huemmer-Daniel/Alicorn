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

## Abstract Supertypes

```@docs
AbstractQuantity
```

#### Interface of AbstractQuantity

The following functions are considered part of the interface of `AbstractQuantity` and need to be extended for all concrete subtypes of `AbstractQuantity`:

```@docs
Base.:(==)(::AbstractQuantity, ::AbstractQuantity)
inUnitsOf(::AbstractQuantity, ::AbstractUnit)
inBasicSIUnits(::AbstractQuantity)
Base.:*(::AbstractQuantity, ::AbstractUnit)
Base.:/(::AbstractQuantity, ::AbstractUnit)
Base.:+(::AbstractQuantity, ::AbstractQuantity)
Base.:-(::AbstractQuantity, ::AbstractQuantity)
Base.:*(::AbstractQuantity, ::AbstractQuantity)
Base.:/(::AbstractQuantity, ::AbstractQuantity)
Base.inv(::AbstractQuantity)
Base.:^(::AbstractQuantity, ::Real)
Base.sqrt(::AbstractQuantity)
Base.transpose(::AbstractQuantity)
```

## SimpleQuantity

```@docs
SimpleQuantity
Base.:(==)(::SimpleQuantity, ::SimpleQuantity)
Base.:*(::Any, ::AbstractUnit)
Base.:/(::Any, ::AbstractUnit)
```
## Dimension

```@docs
Dimension
Base.:*(::Number, ::Dimension)
Base.:+(::Dimension, ::Dimension)
dimensionOf(::AbstractUnit)
dimensionOf(::AbstractQuantity)
```

## InternalUnits

```@docs
InternalUnits
```


```@meta
DocTestSetup = nothing
```

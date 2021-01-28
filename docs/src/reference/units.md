# Units

```@meta
DocTestSetup = quote
    using Alicorn
end
```
## Abstract Supertypes

```@docs
AbstractUnitElement
AbstractUnit
```

### Interface of AbstractUnit

Alicorn extends the following functions from the Base module for `AbstractUnit` types:

```@docs
Base.:*(::AbstractUnit, ::AbstractUnit)
Base.:/(::AbstractUnit, ::AbstractUnit)
```

The following functions are considered part of the interface of `AbstractUnit` and need to be extended for all concrete subtypes of `AbstractUnit`:

```@docs
convertToUnit(::AbstractUnit)
Base.:*(::UnitPrefix, ::AbstractUnit)
Base.inv(::AbstractUnit)
Base.:^(::AbstractUnit, ::Real)
Base.:sqrt(::AbstractUnit)
convertToBasicSI(::AbstractUnit)
Alicorn.convertToBasicSIAsExponents(::AbstractUnit)
```

## UnitPrefix

```@docs
UnitPrefix
Alicorn.emptyUnitPrefix
Alicorn.kilo
```

## BaseUnit

## BaseUnitExponents

## UnitCatalogue

## UnitFactor

## Unit

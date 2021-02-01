```@meta
DocTestSetup = quote
    using Alicorn
end
```

# Units

This section describes the `Units` submodule of Alicorn. The module is concerned with defining and storing physical units, and defines the arithmetic operations available for constructing and combining units.

Unless stated otherwise, all types, functions, and constants defined in the submodule are exported by Alicorn.

#### Contents

```@contents
Pages = ["units.md"]
```

## Overview

To understand how Alicorn structures physical units TODO

## Abstract Supertypes

```@docs
AbstractUnitElement
UnitFactorElement
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

```@docs
BaseUnit
Alicorn.unitlessBaseUnit
Alicorn.gram
Alicorn.meter
Alicorn.second
Alicorn.ampere
Alicorn.kelvin
Alicorn.mol
Alicorn.candela
Base.:*(unitPrefix::UnitPrefix, baseUnit::BaseUnit)
```

## BaseUnitExponents

```@docs
BaseUnitExponents
convertToUnit(::BaseUnitExponents)
Base.:*(::Number, ::BaseUnitExponents)
Base.:+(::BaseUnitExponents, ::BaseUnitExponents)
```

## UnitCatalogue

```@docs
UnitCatalogue
```

## UnitFactor

```@docs
UnitFactor
Alicorn.unitlessUnitFactor
Alicorn.kilogram
```

## Unit

```@docs
Unit
```

```@meta
DocTestSetup = nothing
```

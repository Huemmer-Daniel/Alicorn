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

#### How Units are represented

To understand how Alicorn handles physical units, let us consider the unit
```math
\mathrm{kg} \, \mathrm{nm}^2 \, \mathrm{ps}^{-2}.
```
In Alicorn, this unit is represented by a [`Unit`](@ref) object. The
[`Unit`](@ref) contains three [`UnitFactor`](@ref) objects, representing
1. `UnitFactor`: ``\mathrm{kg}``
2. `UnitFactor`: ``\mathrm{nm}^2``
3. `UnitFactor`: ``\mathrm{ps}^2``
respectively. A [`UnitFactor`](@ref) in turn consists of three elements: a
[`UnitPrefix`](@ref), a [`BaseUnit`](@ref), and a real-valued exponent. The
first unit factor, for instance, is assembled from
* `UnitPrefix`: ``\mathrm{k}`` (kilo)
* `BaseUnit`: ``\mathrm{g}`` (gram)
* `exponent::Real`: ``1``
while for the third
* `UnitPrefix`: ``\mathrm{p}`` (pico)
* `BaseUnit`: ``\mathrm{s}`` (second)
* `exponent::Real`: ``-2``

Each [`BaseUnit`](@ref) represents a named combination of the seven basic units
(kilogram, meter, second, ampere, kelvin, mol, and candela) of the International
System of Units, such as the basic units themselves or derived units such as the
joule. A [`BaseUnit`](@ref) is characterized through a prefactor and the
corresponding powers of the basic units, represented as a
[`BaseUnitExponents`](@ref) object.

#### Type Graph for Representations of Units

There are three types that represent valid physical units: [`BaseUnit`](@ref),
[`UnitFactor`](@ref), and [`Unit`](@ref), in order of increasing complexity.
These types are concrete realizations of the abstract type
[`AbstractUnit`](@ref) which provides an interface defining a set of methods for
physical units.

The complete type graph for constituents of physical units is
```
AbstractUnitElement
├─ UnitPrefix
├─ BaseUnitExponents
└─ AbstractUnit
   ├─ BaseUnit
   ├─ UnitFactor
   └─ Unit
```

The types [`UnitPrefix`](@ref) and [`BaseUnit`](@ref) making up a
[`UnitFactor`](@ref) are collected in the type union [`UnitFactorElement`](@ref).

#### How Units can be constructed

Definitions of [`UnitPrefix`](@ref) and [`BaseUnit`](@ref) objects are collected
in a [`UnitCatalogue`](@ref). Alicorn provides a default catalogue constructed
by `UnitCatalogue()` that contains the most important prefixes and named units.
A natural way to construct composite units like
``\mathrm{kg} \, \mathrm{nm}^2 \, \mathrm{ps}^{-2}`` is by arithmetically
combining unit prefixes and base units:
```jldoctest
julia> ucat = UnitCatalogue() ;

julia> kg = ucat.kilo * ucat.gram
UnitFactor kg
julia> nm2 = (ucat.nano * ucat.meter)^2
UnitFactor nm^2
julia> ps_2 = (ucat.pico * ucat.second)^-2
UnitFactor ps^-2
julia> kg * nm2 * ps_2
Unit kg nm^2 ps^-2
```


## Abstract Supertypes

```@docs
AbstractUnitElement
UnitFactorElement
AbstractUnit
```

#### Interface of AbstractUnit

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
```

#### Constants of type UnitPrefix

```@docs
Alicorn.emptyUnitPrefix
Alicorn.kilo
```

## BaseUnit

```@docs
BaseUnit
```

#### Methods implementing the AbstractUnit interface
```@docs
Base.:*(::UnitPrefix, ::BaseUnit)
Base.inv(::BaseUnit)
Base.:^(::BaseUnit, ::Real)
Base.sqrt(::BaseUnit)
```

#### Constants of type BaseUnit
```@docs
Alicorn.unitlessBaseUnit
Alicorn.gram
Alicorn.meter
Alicorn.second
Alicorn.ampere
Alicorn.kelvin
Alicorn.mol
Alicorn.candela
```

## BaseUnitExponents

```@docs
BaseUnitExponents
convertToUnit(::BaseUnitExponents)
Base.:*(::Number, ::BaseUnitExponents)
Base.:+(::BaseUnitExponents, ::BaseUnitExponents)
```

## UnitFactor

```@docs
UnitFactor
```

#### Methods implementing the AbstractUnit interface

```@docs
Base.:*(::UnitPrefix, ::UnitFactor)
Base.inv(::UnitFactor)
Base.:^(::UnitFactor, ::Real)
Base.sqrt(::UnitFactor)
```

#### Constants of type UnitFactor

```@docs
Alicorn.unitlessUnitFactor
Alicorn.kilogram
```

## Unit

```@docs
Unit
```

#### Methods implementing the AbstractUnit interface

```@docs
Base.:*(::Unit, ::Unit)
Base.:/(::Unit, ::Unit)
Base.:*(::UnitPrefix, ::Unit)
Base.inv(::Unit)
Base.:^(unit::Unit, exponent::Real)
Base.sqrt(::Unit)
```

#### Constants of type Unit

```@docs
Alicorn.unitlessUnit
```

## UnitCatalogue

```@docs
UnitCatalogue
```

#### Methods

```@docs
Base.getproperty(::UnitCatalogue, ::Symbol)
Base.propertynames(::UnitCatalogue)
listUnitPrefixes(::UnitCatalogue)
listBaseUnits(::UnitCatalogue)
listUnitPrefixNames(::UnitCatalogue)
listBaseUnitNames(::UnitCatalogue)
providesUnitPrefix(::UnitCatalogue, ::String)
providesBaseUnit(::UnitCatalogue, ::String)
add!(::UnitCatalogue, ::UnitPrefix)
remove!(::UnitCatalogue, ::String)
```

```@meta
DocTestSetup = nothing
```

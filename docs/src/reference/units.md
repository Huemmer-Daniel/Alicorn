```@meta
DocTestSetup = quote
    using Alicorn
end
```

# Units

The `Units` submodule is concerned with defining and storing physical units, and defines the arithmetic operations available for constructing and combining units.

Unless stated otherwise, all types, functions, and constants defined in the submodule are exported by Alicorn.

#### Contents

```@contents
Pages = ["units.md"]
Depth = 3
```

## Overview

#### How units are represented

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

Each [`BaseUnit`](@ref) represents one of the seven basic units
(kilogram, meter, second, ampere, kelvin, mol, and candela) of the International
System of Units, or a derived unit bearing a special name, such as the joule. A [`BaseUnit`](@ref) is characterized through a prefactor and the
corresponding powers of the basic units, represented as a
[`BaseUnitExponents`](@ref) object.

#### Types representing units

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

#### How units can be constructed

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


## AbstractUnitElement

```@docs
AbstractUnitElement
```


## UnitFactorElement

```@docs
UnitFactorElement
```


## AbstractUnit

```@docs
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
Base.:cbrt(::AbstractUnit)
convertToBasicSI(::AbstractUnit)
Alicorn.convertToBasicSIAsExponents(::AbstractUnit)
dimensionOf(::AbstractUnit)
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
Base.cbrt(::BaseUnit)
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
Base.cbrt(::UnitFactor)
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
Base.cbrt(::Unit)
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


#### Default UnitCatalogue

Calling the [`UnitCatalogue`](@ref) constructor without arguments returns a catalogue
that contains a default set of common units and prefixes used with the SI system:
```jldoctest
julia> ucat = UnitCatalogue()
UnitCatalogue providing
 21 unit prefixes
 43 base units
```

#### Default unit prefixes

The default prefixes are listed in the following table. The corresponding
[`UnitPrefix`](@ref) objects are constructed as
```jldoctest
julia> yotta = UnitPrefix( name="yotta", symbol="Y", value=1e+24 )
UnitPrefix yotta (Y) of value 1e+24
```
and can be selected from the default [`UnitCatalogue`](@ref) by
```jldoctest; setup = :( ucat = UnitCatalogue() )
julia> ucat.yotta
UnitPrefix yotta (Y) of value 1e+24
```
and so on.

| name      | symbol    | value |
| :---      | :---:     | :---  |
| "yotta"   | "Y"       | 1e+24 |
| "zetta"   | "Z"       | 1e+21 |
| "exa"     | "E"       | 1e+18 |
| "peta"    | "P"       | 1e+15 |
| "tera"    | "T"       | 1e+12 |
| "giga"    | "G"       | 1e+9  |
| "mega"    | "M"       | 1e+6  |
| "kilo"    | "k"       | 1e+3  |
| "hecto"   | "h"       | 1e+2  |
| "deca"    | "da"      | 1e+1  |
| "deci"    | "d"       | 1e-1  |
| "centi"   | "c"       | 1e-2  |
| "milli"   | "m"       | 1e-3  |
| "micro"   | "μ"       | 1e-6  |
| "nano"    | "n"       | 1e-9  |
| "pico"    | "p"       | 1e-12 |
| "femto"   | "f"       | 1e-15 |
| "atto"    | "a"       | 1e-18 |
| "zepto"   | "z"       | 1e-21 |
| "yocto"   | "y"       | 1e-24 |
| "empty"   | "<empty>" | 1     |

#### Default named units

The default named units are listed in the following table. The corresponding
[`BaseUnit`](@ref) objects are constructed as
```jldoctest
julia> gram = BaseUnit( name="gram", symbol="g", prefactor=1e-3, exponents=BaseUnitExponents(kg=1) )
BaseUnit gram (1 g = 1e-3 kg)
```
and can be selected from the default [`UnitCatalogue`](@ref) by
```jldoctest; setup = :( ucat = UnitCatalogue() )
julia> ucat.gram
BaseUnit gram (1 g = 1e-3 kg)
```
and so on.

| name               | symbol       | prefactor          | exponents                                  | corresponding basic unit                                                    |
| :---               | :---:        | :---               | :---                                       | :---                                                                        |
| "gram"             | "g"          | 1e-3               | `BaseUnitExponents(kg=1)`                  | ``10^{-3}\,\mathrm{kg}``                                                    |
| "meter"            | "m"          | 1                  | `BaseUnitExponents(m=1)`                   | ``1\,\mathrm{m}``                                                           |
| "second"           | "s"          | 1                  | `BaseUnitExponents(s=1)`                   | ``1\,\mathrm{s}``                                                           |
| "ampere"           | "A"          | 1                  | `BaseUnitExponents(A=1)`                   | ``1\,\mathrm{A}``                                                           |
| "kelvin"           | "K"          | 1                  | `BaseUnitExponents(K=1)`                   | ``1\,\mathrm{K}``                                                           |
| "mol"              | "mol"        | 1                  | `BaseUnitExponents(mol=1)`                 | ``1\,\mathrm{mol}``                                                         |
| "candela"          | "cd"         | 1                  | `BaseUnitExponents(cd=1)`                  | ``1\,\mathrm{cd}``                                                          |
| "hertz"            | "Hz"         | 1                  | `BaseUnitExponents(s=-1)`                  | ``1\,\mathrm{s}^{-1}``                                                      |
| "radian"           | "rad"        | 1                  | `BaseUnitExponents()`                      | ``1``                                                                       |
| "steradian"        | "sr"         | 1                  | `BaseUnitExponents()`                      | ``1``                                                                       |
| "newton"           | "N"          | 1                  | `BaseUnitExponents(kg=1, m=1, s=-2)`       | ``1\,\mathrm{kg}\,\mathrm{m}\,\mathrm{s}^{-2}``                             |
| "pascal"           | "Pa"         | 1                  | `BaseUnitExponents(kg=1, m=-1, s=-2)`      | ``1\,\mathrm{kg}\,\mathrm{m}^{-1}\,\mathrm{s}^{-2}``                        |
| "joule"            | "J"          | 1                  | `BaseUnitExponents(kg=1, m=2, s=-2)`       | ``1\,\mathrm{kg}\,\mathrm{m}^2\,\mathrm{s}^{-2}``                           |
| "watt"             | "W"          | 1                  | `BaseUnitExponents(kg=1, m=2, s=-3)`       | ``1\,\mathrm{kg}\,\mathrm{m}^2\,\mathrm{s}^{-3}``                           |
| "coulomb"          | "C"          | 1                  | `BaseUnitExponents(s=1, A=1)`              | ``1\,\mathrm{s}\,\mathrm{A}``                                               |
| "volt"             | "V"          | 1                  | `BaseUnitExponents(kg=1, m=2, s=-3, A=-1)` | ``1\,\mathrm{kg}\,\mathrm{m}^2\,\mathrm{s}^{-3}\,\mathrm{A}^{-1}``          |
| "farad"            | "F"          | 1                  | `BaseUnitExponents(kg=-1, m=-2, s=4, A=2)` | ``1\,\mathrm{kg}^{-1}\,\mathrm{m}^{-2}\,\mathrm{s}^4\,\mathrm{A}^2``        |
| "ohm"              | "Ω"          | 1                  | `BaseUnitExponents(kg=1, m=2, s=-3, A=-2)` | ``1\,\mathrm{kg}\,\mathrm{m}^2\,\mathrm{s}^{-3}\,\mathrm{A}^{-2}``          |
| "siemens"          | "S"          | 1                  | `BaseUnitExponents(kg=-1, m=-2, s=3, A=2)` | ``1\,\mathrm{kg}^{-1}\,\mathrm{m}^{-2}\,\mathrm{s}^3\,\mathrm{A}^2``        |
| "weber"            | "W"          | 1                  | `BaseUnitExponents(kg=1, m=2, s=-2, A=-1)` | ``1\,\mathrm{kg}\,\mathrm{m}^2\,\mathrm{s}^{-2}\,\mathrm{A}^{-1}``          |
| "tesla"            | "T"          | 1                  | `BaseUnitExponents(kg=1, s=-2, A=-1)`      | ``1\,\mathrm{kg}\,\mathrm{s}^{-2}\,\mathrm{A}^{-1}``                        |
| "henry"            | "H"          | 1                  | `BaseUnitExponents(kg=1, m=2, s=-2, A=-2)` | ``1\,\mathrm{kg}\,\mathrm{m}^2\,\mathrm{s}^{-2}\,\mathrm{A}^{-2}``          |
| "degreeCelsius"    | "°C"         | 1                  | `BaseUnitExponents(K=1)`                   | ``1\,\mathrm{K}``                                                           |
| "lumen"            | "lm"         | 1                  | `BaseUnitExponents(cd=1)`                  | ``1\,\mathrm{cd}``                                                          |
| "lux"              | "lx"         | 1                  | `BaseUnitExponents(m=-2, cd=1)`            | ``1\,\mathrm{m}^{-2}\,\mathrm{cd}``                                         |
| "becquerel"        | "Bq"         | 1                  | `BaseUnitExponents(s=-1)`                  | ``1\,\mathrm{s}^{-1}``                                                      |
| "gray"             | "Gy"         | 1                  | `BaseUnitExponents(m=2, s=-2)`             | ``1\,\mathrm{m}^2\,\mathrm{s}^{-2}``                                        |
| "sievert"          | "Sv"         | 1                  | `BaseUnitExponents(m=2, s=-2)`             | ``1\,\mathrm{m}^2\,\mathrm{s}^{-2}``                                        |
| "katal"            | "kat"        | 1                  | `BaseUnitExponents(s=-1, mol=1)`           | ``1\,\mathrm{s}^{-1}\,\mathrm{mol}``                                        |
| "minute"           | "min"        | 60                 | `BaseUnitExponents(s=1)`                   | ``60\,\mathrm{s}``                                                          |
| "hour"             | "h"          | 3600               | `BaseUnitExponents(s=1)`                   | ``3600\,\mathrm{s}``                                                        |
| "day"              | "d"          | 86400              | `BaseUnitExponents(s=1)`                   | ``86400\,\mathrm{s}``                                                       |
| "astronomicalUnit" | "au"         | 149597870700       | `BaseUnitExponents(m=1)`                   | ``149597870700\,\mathrm{m}``                                                |
| "degree"           | "°"          | pi/180             | `BaseUnitExponents()`                      | ``\pi/180``                                                                 |
| "arcminute"        | "'"          | pi/10800           | `BaseUnitExponents()`                      | ``\pi/10800``                                                               |
| "arcsecond"        | "\""         | pi/648000          | `BaseUnitExponents()`                      | ``\pi/648000``                                                              |
| "hectare"          | "ha"         | 1e4                | `BaseUnitExponents(m=2)`                   | ``10^4\,\mathrm{m}^2``                                                      |
| "liter"            | "l"          | 1e-3               | `BaseUnitExponents(m=3)`                   | ``10^{-3}\,\mathrm{m}^3``                                                   |
| "tonne"            | "t"          | 1e3                | `BaseUnitExponents(kg=1)`                  | ``10^3\,\mathrm{kg}``                                                       |
| "dalton"           | "Da"         | 1.66053906660e-27  | `BaseUnitExponents(kg=1)`                  | ``1.66053906660 \times 10^{-27}\,\mathrm{kg}``                              |
| "electronvolt"     | "eV"         | 1.602176634e-19    | `BaseUnitExponents(kg=1, m=2, s=-2)`       | ``1.602176634 \times 10^{-19}\,\mathrm{kg}\,\mathrm{m}^2\,\mathrm{s}^{-2}`` |
| "angstrom"         | "Å"          | 1e-10              | `BaseUnitExponents(m=1)`                   | ``10^{-10}\,\mathrm{m}``                                                    |
| "unitless"         | "<unitless>" | 1                  | `BaseUnitExponents()`                      | ``1``                                                                       |


```@meta
DocTestSetup = nothing
```

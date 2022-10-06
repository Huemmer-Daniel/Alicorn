# Alicorn

*Dynamically define and manipulate physical units and quantities in Julia*

**Build Status:**
[![Build status][build-status-badge]][build-status-url]
[![Codecov status][codecov-badge]][codecov-url]
[![Coverall status][coverall-badge]][coverall-url]

**Documentation:**
[![Documentation stable][docs-stable-badge]][docs-stable-url]
[![Documentation development][docs-dev-badge]][docs-dev-url]

The `Alicorn.jl` package serves a dual purpose:
1. Dynamically define and combine physical units based on the
   [International System of Units (SI)](https://www.bipm.org/en/publications/si-brochure/).
   This functionality is provided by the `Units` submodule.
2. Handle physical quantities and correctly treat their units. This
   functionality is provided by the `Quantities` submodule.

 ## Features

 * Alicorn represents units as objects of type `AbstractUnit` with
   suitable methods to create and manipulate them
 * Alicorn represents quantities as objects of type `AbstractQuantity` for scalars and `AbstractQuantityArray` for vectors and matrices, with suitable methods to create and manipulate them
 * Units can be combined and quantities formed using **intuitive arithmetic syntax**,
   no parsing of strings representing units is required
 * New units can be **dynamically defined during runtime**, no manipulation of
   source files or configuration files is required
 * Alicorn provides two concrete implementations of `AbstractQuantity` and `AbstractQuantityArray`:
   - `SimpleQuantity` and `SimpleQuantityArray`, which explicitly contain a physical unit and is therefore easy to read and interpret.
   - `Quantity` and `QuantityArray`, which store only the physical dimension and reference a common set of `InternalUnits`. This structure reduces the need for unit conversions and is therefore particularly useful in larger numerical operations.
 * Both kinds of quantities can be freely combined to allow intuitive manipulation of quantities.

## Installation

The `Alicorn.jl` package is registered in the [General Julia registry](https://github.com/JuliaRegistries/General) and can be installed using Julia's package manager [`Pkg.jl`](https://julialang.github.io/Pkg.jl/): In the Julia REPL, add Alicorn to your default Julia environment by running
```
julia> ]

pkg> add Alicorn
```


## Quick Start

The listing below shows a minimal example of how to use Alicorn. Refer to the [Basic Usage](https://huemmer-daniel.github.io/Alicorn/stable/manual/basic_usage/) section for more details.

First, let us calculate a force as a `SimpleQuantity`:
```jldoctest
julia> using Alicorn

julia> ucat = UnitCatalogue() ;

julia> mass = 2 * (ucat.kilo * ucat.gram)
2 kg

julia> acceleration = 10 * ucat.meter * ucat.second^-2
10 m s^-2

julia> force = mass * acceleration
20 kg m s^-2

julia> inUnitsOf(force, ucat.kilo * ucat.newton)
0.02 kN
```
We can perform the same caluclation using `Quantity`, choosing a set of `InternalUnits` first:
```jldoctest
julia> using Alicorn

julia> ucat = UnitCatalogue() ;

julia> intu = InternalUnits(mass = 2 * ucat.gram ) ;

julia> mass = Quantity(2 * (ucat.kilo * ucat.gram), intu)
Quantity{Int64} of dimension M^1 in units of (2 g):
 1000

julia> acceleration = Quantity(10 * ucat.meter * ucat.second^-2, intu)
Quantity{Int64} of dimension L^1 T^-2 in units of (1 m, 1 s):
 10

julia> force = mass * acceleration
Quantity{Int64} of dimension M^1 L^1 T^-2 in units of (2 g, 1 m, 1 s):
 10000

julia> inUnitsOf(force, ucat.kilo * ucat.newton)
0.02 kN
```

## Alternative

If you are interested in Alicorn, also have a look at the mature [`Unitful.jl`](https://github.com/PainterQubits/Unitful.jl) package. `Unitful.jl` offers functionalities similar to `Alicorn.jl`, and more.

[build-status-badge]: https://github.com/Huemmer-Daniel/Alicorn/workflows/build/badge.svg
[build-status-url]: https://github.com/Huemmer-Daniel/Alicorn/actions

[codecov-badge]: https://codecov.io/gh/Huemmer-Daniel/Alicorn/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/Huemmer-Daniel/Alicorn

[coverall-badge]: https://coveralls.io/repos/github/Huemmer-Daniel/Alicorn/badge.svg?branch=master
[coverall-url]: https://coveralls.io/github/Huemmer-Daniel/Alicorn?branch=master

[docs-stable-badge]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://huemmer-daniel.github.io/Alicorn/stable/

[docs-dev-badge]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://huemmer-daniel.github.io/Alicorn/dev/

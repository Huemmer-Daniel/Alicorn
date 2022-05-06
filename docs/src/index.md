# The Alicorn.jl package

*Dynamically define and manipulate physical units and quantities in Julia*

The Alicorn package serves a dual purpose:
1. Dynamically define and combine physical units based on the
   [International System of Units (SI)](https://www.bipm.org/en/publications/si-brochure/).
   This functionality is provided by the `Units` submodule.
2. Handle physical quantities and correctly treat their units. This
   functionality is provided by the `Quantities` submodule.

## Documentation

This documentation is divided into two parts: The **Manual** describes how to use
Alicorn to define units and handle physical quantities. The **Reference** documents
all types, methods, and constants that form the public API of Alicorn.

## Features

* Alicorn represents units as objects of type [`AbstractUnit`](@ref) with
  suitable methods to create and manipulate them
* Alicorn represents quantities as objects of type [`AbstractQuantity`](@ref) for scalars and [`AbstractQuantityArray`](@ref) for vectors and matrices, with suitable methods to create and manipulate them
* Units can be combined and quantities formed using **intuitive arithmetic syntax**,
  no parsing of strings representing units is required
* New units can be **dynamically defined during runtime**, no manipulation of
  source files or configuration files is required
* Alicorn provides two concrete implementations of [`AbstractQuantity`](@ref) and [`AbstractQuantityArray`](@ref): First, [`SimpleQuantity`](@ref) and [`SimpleQuantityArray`](@ref), which explicitly contain a physical unit and is therefore easy to read and interpret. Second, [`Quantity`](@ref) and [`QuantityArray`](@ref), which store only the physical dimension and reference a common set of [`InternalUnits`](@ref). This structure reduces the need for unit conversions and is therefore particularly useful in larger numerical operations.
* Both kinds of quantities can be freely combined to allow intuitive manipulation of quantities.

## Installation

The `Alicorn.jl` package is registered in the [General Julia registry](https://github.com/JuliaRegistries/General) and can be installed using Julia's package manager [`Pkg.jl`](https://julialang.github.io/Pkg.jl/): In the Julia REPL, add Alicorn to your default Julia environment by running
```
julia> ]

pkg> add Alicorn
```

## Quick Start

The listing below shows a minimal example of how to use Alicorn. Refer to the [Basic Usage](@ref) section for more details.

First, let us calculate a force as a [`SimpleQuantity`](@ref):
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
We can perform the same caluclation using [`Quantity`](@ref), choosing a set of [`InternalUnits`](@ref) first:
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

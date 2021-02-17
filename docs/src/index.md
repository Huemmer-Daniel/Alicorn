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

* Alicorn represents units as **objects** of type [`AbstractUnit`](@ref) with
  suitable methods to create and manipulate them
* Alicorn represents quantities as **objects** of type [`AbstractQuantity`](@ref)
  with suitable methods to create and manipulate them
* Units can be combined and quantities formed using **intuitive arithmetic syntax**,
  no parsing of strings representing units is required
* New units can be **dynamically defined during runtime**, no manipulation of
  source files or configuration files is required

## Quick Start

The listing below shows a minimal example of how to use Alicorn. Refer to the [Basic Usage](@ref) section for more details.

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

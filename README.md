# Alicorn

**Build Status:**
[![Build status][build-status-badge]][build-status-url]
[![Coverage status][codecov-badge]][codecov-url]

**Documentation:**
[![Documentation stable][docs-stable-badge]][docs-stable-url]
[![Documentation development][docs-dev-badge]][docs-dev-url]

*Dynamically define and manipulate physical units and quantities in Julia*

The Alicorn package serves a dual purpose:
1. Dynamically define and combine physical units based on the
   [International System of Units (SI)](https://www.bipm.org/en/publications/si-brochure/).
   This functionality is provided by the `Units` submodule.
2. Handle physical quantities and correctly treat their units. This
   functionality is provided by the `Quantities` submodule.

[build-status-badge]: https://github.com/Huemmer-Daniel/Alicorn/workflows/build/badge.svg
[build-status-url]: https://github.com/Huemmer-Daniel/Alicorn/actions

[codecov-badge]: https://codecov.io/gh/Huemmer-Daniel/Alicorn/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/Huemmer-Daniel/Alicorn

[docs-stable-badge]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://huemmer-daniel.github.io/Alicorn/stable/

[docs-dev-badge]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://huemmer-daniel.github.io/Alicorn/dev/


## Quick Start

The listing below shows a minimal example of how to use Alicorn. Refer to the [Basic Usage](@ref) section for more details.

```
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

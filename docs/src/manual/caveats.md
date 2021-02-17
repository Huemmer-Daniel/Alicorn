```@meta
DocTestSetup = quote
    using Alicorn
end
```

# Caveats

#### Contents

```@contents
Pages = ["caveats.md"]
```

## Temperatures are relative

Alicorn treats temperatures (as well as all other quantities) as relative rather
than absolute. In consequence, when converting from kelvin to degrees celsius,
no offset is added:
```jldoctest
julia> ucat = UnitCatalogue() ;

julia> T = 20 * ucat.degreeCelsius
20 °C

julia> inUnitsOf(T, ucat.kelvin)
20.0 K
```

## Only dimensions are compared

Alicorn is only aware of physical dimensions, not of the physical quantities
as such. The responsibility to choose units suitable for a given
physical quantity rests with the user. For example, it is possible to add
two quantities that have the same dimension but represent different physical
concepts, such as angles and solid angles:
```jldoctest
julia> ucat = UnitCatalogue() ;

julia> solidAngle = 1 * ucat.steradian
1 sr

julia> angle = 1 * ucat.degree
1 °

julia> nonsense = angle + solidAngle
58.29577951308232 °
```

```@meta
DocTestSetup = nothing
```

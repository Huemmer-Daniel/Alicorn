# Advanced Usage

#### Contents

```@contents
Pages = ["advanced_usage.md"]
```

## Creating an empty UnitCatalogue

An empty [`UnitCatalogue`](@ref) can be initialized by explicitly passing empty
lists of prefixes and units to the constructor:
```@jldoctest
julia> emptyUcat = UnitCatalogue([],[])
UnitCatalogue providing
 0 unit prefixes
 0 base units
```
Users can then fill the catalogue with custom definitions.

## Adding a new UnitPrefix or BaseUnit to a UnitCatalogue

## Removing a UnitPrefix or BaseUnit from a UnitCatalogue

## Extending a mathematical operation to work with the SimpleQuantity type

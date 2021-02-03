using ..Utils

export UnitPrefix
"""
    UnitPrefix  <: AbstractUnitElement

Metric prefix that can precede a base unit. The prefix indicates that the unit is scaled by a corresponding factor.

# Fields
- `name::String`: long form name of the prefix
- `symbol::String`: short symbol used to denote the prefix in a composite unit
- `value`: numerical value of the prefix

# Constructor
```
UnitPrefix(;name::String, symbol::String, value::Real)
```
The string `name` needs to be valid as an identifier. The number `value` needs to be finite.

# Raises Exceptions
- `Core.ArgumentError`: if attempting to initialize the `name` field with a string that is not valid as an identifier
- `Core.DomainError`: if attempting to initialize the `value` field with an infinite number

# Examples
The prefix "milli" for the International System of Units is by default defined in Alicorn as
```jldoctest
julia> UnitPrefix(name="milli", symbol="m", value=1e-3)
UnitPrefix milli (m) of value 1e-3
```
"""
struct UnitPrefix <: AbstractUnitElement
    name::String
    symbol::String
    value::Real

    function UnitPrefix(;name::String, symbol::String, value::Real)
        Utils.assertIsFinite(value)
        Utils.assertNameIsValidSymbol(name)
        new(name, symbol, value)
    end
end

## Constants of type UnitPrefix

export emptyUnitPrefix
"""
Constant of type `UnitPrefix` that indicates the absence of a unit prefix.

The prefix `emptyUnitPrefix` is used to construct [`UnitFactor`](@ref) objects without a unit prefix. The constant is not exported by Alicorn but can be accessed as `Alicorn.emptyUnitPrefix`
"""
const emptyUnitPrefix = UnitPrefix(name="empty", symbol="<empty>", value=1)

export kilo
"""
Constant of type `UnitPrefix` that represents the SI prefix "kilo".

The prefix `kilo` is used to define the basic SI unit [`kilogram`](@ref). The constant is not exported by Alicorn but can be accessed as `Alicorn.kilo`
"""
const kilo = UnitPrefix(name="kilo", symbol="k", value=1e+3)

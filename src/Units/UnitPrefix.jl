using ..Utils

export UnitPrefix
"""
    UnitPrefix  <: AbstractUnitElement

Metric prefix that can precede a base unit. The prefix indicates that the unit is scaled by
a corresponding factor.

Each UnitPrefix has three fields: name, symbol, and value. The prefix "milli" for the Internaional System of Units, for example, is by default defined in Alicorn as
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

export emptyUnitPrefix
"""
    emptyUnitPrefix = UnitPrefix(name="empty", symbol="<empty>", value=1)

Constant that indicates the absence of a unit prefix.

The unit prefix `Alicorn.emptyUnitPrefix` is used to construct UnitFactors without a unit prefix.
"""
const emptyUnitPrefix = UnitPrefix(name="empty", symbol="<empty>", value=1)

export kilo
"""
    kilo = UnitPrefix(name="kilo", symbol="k", value=1e+3)

Constant that represents the SI prefix "kilo".

The unit prefix `Alicorn.kilo` is used to define the basic SI unit `Alicorn.kilogram`.
"""
const kilo = UnitPrefix(name="kilo", symbol="k", value=1e+3)

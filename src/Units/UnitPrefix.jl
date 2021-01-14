using ..Utils

export UnitPrefix
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
emptyUnitPrefix = UnitPrefix(name = "empty", symbol = "<empty>", value = 1)

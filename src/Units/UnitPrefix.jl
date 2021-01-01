using ..Utils

export UnitPrefix
struct UnitPrefix <: UnitElement
    name::String
    symbol::String
    value::Real

    function UnitPrefix(;name::String,symbol::String,value::Real)
        Utils.assertIsFinite(value)
        Utils.assertNameIsValidSymbol(name)
        new(name, symbol, value)
    end
end

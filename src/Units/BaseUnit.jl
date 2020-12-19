using ..Utils

export BaseUnit
struct BaseUnit
    name::String
    symbol::String
    prefactor::Real
    exponents::BaseUnitExponents

    function BaseUnit(; name::String, symbol::String, prefactor::Real, exponents::BaseUnitExponents)
        Utils.assertIsFinite(prefactor)
        Utils.assertNameIsValidSymbol(name)
        new(name, symbol, prefactor, exponents)
    end
end

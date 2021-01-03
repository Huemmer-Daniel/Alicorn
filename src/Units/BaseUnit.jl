using ..Utils

export BaseUnit
struct BaseUnit <: UnitElement
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

export unitlessBaseUnit
unitlessBaseUnit = BaseUnit(name = "unitless", symbol = "<unitless>", prefactor = 1, exponents = BaseUnitExponents())

using ..Utils

export BaseUnit
struct BaseUnit <: AbstractUnit
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

function Base.inv(baseUnit::BaseUnit)
    return inv( UnitFactor(baseUnit) )
end

function Base.:^(baseUnit::BaseUnit, exponent::Real)
    return UnitFactor(baseUnit)^exponent
end

function Base.:*(unitPrefix::UnitPrefix, baseUnit::BaseUnit)
    return UnitFactor(unitPrefix, baseUnit)
end

function convertToUnit(baseUnit::BaseUnit)
    return Unit( UnitFactor(baseUnit) )
end

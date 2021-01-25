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
unitlessBaseUnit = BaseUnit( name = "unitless", symbol = "<unitless>", prefactor = 1, exponents = BaseUnitExponents() )

export gram
gram = BaseUnit( name = "gram", symbol = "g", prefactor = 1e-3, exponents = BaseUnitExponents(kg=1) )

export meter
meter = BaseUnit( name="meter", symbol="m", prefactor=1, exponents=BaseUnitExponents(m=1) )

export second
second = BaseUnit( name="second", symbol="s", prefactor=1, exponents=BaseUnitExponents(s=1) )

export ampere
ampere = BaseUnit( name="ampere", symbol="A", prefactor=1, exponents=BaseUnitExponents(A=1) )

export kelvin
kelvin = BaseUnit( name="kelvin", symbol="K", prefactor=1, exponents=BaseUnitExponents(K=1) )

export mol
mol = BaseUnit( name="mol", symbol="mol", prefactor=1, exponents=BaseUnitExponents(mol=1) )

export candela
candela = BaseUnit( name="candela", symbol="cd", prefactor=1, exponents=BaseUnitExponents(cd=1) )

function Base.inv(baseUnit::BaseUnit)
    return inv( UnitFactor(baseUnit) )
end

function Base.:^(baseUnit::BaseUnit, exponent::Real)
    return UnitFactor(baseUnit)^exponent
end

function Base.sqrt(baseUnit::BaseUnit)
    return UnitFactor(baseUnit)^0.5
end

function Base.:*(unitPrefix::UnitPrefix, baseUnit::BaseUnit)
    return UnitFactor(unitPrefix, baseUnit)
end

function convertToUnit(baseUnit::BaseUnit)
    return Unit( UnitFactor(baseUnit) )
end

function convertToBasicSI(baseUnit::BaseUnit)
    prefactor = baseUnit.prefactor
    exponents = baseUnit.exponents

    basicSIUnit = convertToUnit(exponents)

    return (prefactor, basicSIUnit)
end

function convertToBasicSIAsExponents(baseUnit::BaseUnit)
    prefactor = baseUnit.prefactor
    exponents = baseUnit.exponents

    return (prefactor, exponents)
end

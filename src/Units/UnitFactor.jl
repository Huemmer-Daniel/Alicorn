using ..Utils

export UnitFactor
struct UnitFactor
    unitPrefix::UnitPrefix
    baseUnit::BaseUnit
    exponent::Real

    function UnitFactor(unitPrefix::UnitPrefix, baseUnit::BaseUnit, exponent::Real)
        Utils.assertIsFinite(exponent)
        Utils.assertIsNonzero(exponent)
        return new(unitPrefix, baseUnit, exponent)
    end
end

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

    function UnitFactor(baseUnit::BaseUnit, exponent::Real)
        Utils.assertIsFinite(exponent)
        Utils.assertIsNonzero(exponent)
        return new(emptyUnitPrefix, baseUnit, exponent)
    end

    function UnitFactor(unitPrefix::UnitPrefix, baseUnit::BaseUnit)
        return new(unitPrefix, baseUnit, 1)
    end

    function UnitFactor(baseUnit::BaseUnit)
        return new(emptyUnitPrefix, baseUnit, 1)
    end
end

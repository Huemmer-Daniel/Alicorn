using ..Utils

export UnitFactor
struct UnitFactor <: AbstractUnit
    unitPrefix::UnitPrefix
    baseUnit::BaseUnit
    exponent::Real

    function UnitFactor(unitPrefix::UnitPrefix, baseUnit::BaseUnit, exponent::Real)
        Utils.assertIsFinite(exponent)
        Utils.assertIsNonzero(exponent)
        _assertEmptyPrefixIfUnitless(baseUnit, unitPrefix)
        _assertTrivialExponentIfUnitless(baseUnit, exponent)
        exponent = Utils.tryCastingToInt(exponent)
        return new(unitPrefix, baseUnit, exponent)
    end
end

function _assertEmptyPrefixIfUnitless(baseUnit::BaseUnit, unitPrefix::UnitPrefix)
    if baseUnit == unitlessBaseUnit && unitPrefix != emptyUnitPrefix
        throw( Core.ArgumentError("unitless BaseUnit requires empty UnitPrefix") )
    end
end

function _assertTrivialExponentIfUnitless(baseUnit::BaseUnit, exponent::Real)
    if baseUnit == unitlessBaseUnit && exponent != 1
        throw( Core.ArgumentError("unitless BaseUnit requires exponent 1") )
    end
end

Base.broadcastable(unitFactor::UnitFactor) = Ref(unitFactor)

function UnitFactor(baseUnit::BaseUnit, exponent::Real)
    return UnitFactor(emptyUnitPrefix, baseUnit, exponent)
end

function UnitFactor(unitPrefix::UnitPrefix, baseUnit::BaseUnit)
    return UnitFactor(unitPrefix, baseUnit, 1)
end

function UnitFactor(baseUnit::BaseUnit)
    return UnitFactor(emptyUnitPrefix, baseUnit, 1)
end

function UnitFactor()
    return UnitFactor(emptyUnitPrefix, unitlessBaseUnit, 1)
end

export unitlessUnitFactor
unitlessUnitFactor = UnitFactor( emptyUnitPrefix, unitlessBaseUnit, 1)
